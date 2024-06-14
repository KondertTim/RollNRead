import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:vector_math/vector_math_64.dart';

class Scan extends StatefulWidget {
  const Scan({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan>{
  late CameraController controller;
  late CameraDescription description;

  Image? image;
  FileSystem fs = MemoryFileSystem();

  @override
  void initState() {
    super.initState();

    if(widget.cameras.isEmpty) {
      return;
    }

    description = widget.cameras[0];
    controller = CameraController(description, ResolutionPreset.high, enableAudio: false, fps: 5, imageFormatGroup: ImageFormatGroup.yuv420);

    controller.initialize().then((_) {
      if(!mounted) {
        return;
      }
      setState(() {});
      controller.getMaxZoomLevel().then((maxZoom) {
        controller.setZoomLevel(min(2, maxZoom));
        controller.startImageStream(_processFrame);
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          default:
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.stopImageStream();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(!controller.value.isInitialized) {
      return  const Scaffold(body: Center(child: Text("Could not initialize camera"),));
    }
    return Scaffold(body: Center(child: image));
  }

  cv.Mat _parseFrame(CameraImage image) {
    var width = image.width;
    var height = image.height;
    var convert;

    var bytes = BytesBuilder();
    bytes.add(image.planes.first.bytes);
    bytes.add(image.planes[1].bytes);

    // iOS uses bi-planar NV12 for YUV420
    // Android on the other hand produces IYUV/I420 on three planes

    if(Platform.isIOS) {
      convert = cv.COLOR_YUV2BGR_NV12;
    }

    // On iOS the YUV Image is in two planes
    // Android on the other hand splits it into three
    if(Platform.isAndroid) {
      bytes.add(image.planes[2].bytes);
      convert = cv.COLOR_YUV2BGR_IYUV;
    }

    var yuv = cv.Mat.fromList((height / 2 * 3).ceil(), width, cv.MatType.CV_8UC1, bytes.toBytes(), image.planes.first.bytesPerRow);

    var img = cv.cvtColor(yuv, convert);

    // Androids sensor output has to be rotated by 90 degrees
    // Output from iOS is already upright, even though Flutters CameraDescription says otherwise
    if(Platform.isAndroid) {
      return cv.rotate(img, cv.ROTATE_90_CLOCKWISE);
    } else {
      return img;
    }
  }

  Uint8List _produceFrame(cv.Mat frame) {
    return cv.imencode(".jpg", frame);
  }

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<void> _runOCR(List<Uint8List> images) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    for(var image in images) {
      File file = fs.file('${getRandomString(20)}_image.jpg')
        ..writeAsBytesSync(image);
      final RecognizedText recognizedText = await textRecognizer.processImage(InputImage.fromFile(file));
      file.deleteSync();

      String text = recognizedText.text;
      print(text);
    }
  }

  void _updateFrame(Uint8List frame) {
    setState(() {
      image = Image.memory(frame, gaplessPlayback: true);
    });
  }

  void _processFrame(CameraImage image) {
    var frame = _parseFrame(image);

    var green = cv.Scalar(0, 255, 0, 0);

    var threshold = 50;

    var orb = cv.ORB.create();
    var kp = orb.detectAndCompute(frame, cv.Mat.empty());

    var points = kp.$1.toList();
    var mask = cv.Mat.zeros(frame.height, frame.width, cv.MatType.CV_8UC1);

    Map<cv.KeyPoint, cv.Mat> objects = {};

    cv.Mat point_mask;
    for(var p in points) {
      point_mask = cv.Mat.zeros(frame.height, frame.width, cv.MatType.CV_8UC1);
      cv.circle(point_mask, cv.Point(p.x.round(), p.y.round()), threshold, cv.Scalar.white, thickness: cv.FILLED);

      cv.bitwiseOR(mask, point_mask, dst: mask);

      var alone = true;
      for(var o in objects.values) {
        if(mask.at<num>(p.y.round(), p.x.round()) != 0) {
          cv.bitwiseOR(o, point_mask, dst: o);
          alone = false;
          break;
        }
      }

      if(alone) {
        objects[p] = point_mask;
      }
    }

    List<Uint8List> images = [];
    for(var o in objects.entries) {
      var contours = cv.findContours(o.value, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE);
      frame = cv.drawContours(frame, contours.$1, -1, green);

      var obj = cv.cvtColor(frame, cv.COLOR_BGR2GRAY);
      cv.bitwiseAND(o.value, obj, dst: obj);
      cv.cvtColor(obj, cv.COLOR_GRAY2BGR, dst: obj);
      Uint8List bytes = cv.imencode(".jpg", frame);
      images.add(bytes);
    }

    _runOCR(images);

    var out = _produceFrame(frame);
    _updateFrame(out);
    return;
  }
}
