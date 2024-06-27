import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

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
  int? detected;
  DateTime lastOCR = DateTime(1990);

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
    return Scaffold(body: Column(children: [
      Expanded(child: Center(child: image)),
      if(detected != null)
        SizedBox(height: 100, child: Text(detected.toString(), style: TextStyle(fontSize: 70),),)
    ],));
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

  Future<void> _runOCR(List<InputImage> images) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final d20 = RegExp(r"^1?\d$|^20$");

    for(var image in images) {
      final RecognizedText recognizedText = await textRecognizer.processImage(image);
      String text = recognizedText.text;

      if(d20.hasMatch(text)) {
        print(text);
        detected = int.parse(text);
        return;
      }
    }
  }

  void _updateFrame(Uint8List frame) {
    setState(() {
      image = Image.memory(frame, gaplessPlayback: true, fit: BoxFit.scaleDown);
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
        if(o.at<num>(p.y.round(), p.x.round()) != 0) {
          cv.bitwiseOR(o, point_mask, dst: o);
          alone = false;
          break;
        }
      }

      if(alone) {
        objects[p] = point_mask;
      }
    }

    if(DateTime.now().millisecondsSinceEpoch > (lastOCR.millisecondsSinceEpoch + 1000)) {
      List<InputImage> images = [];

      for(var o in objects.entries) {
        //var contours = cv.findContours(o.value, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE);
        //cv.drawContours(frame, contours.$1, -1, green);

        var obj = cv.cvtColor(frame, cv.COLOR_BGR2GRAY);
        cv.bitwiseAND(o.value, obj, dst: obj);

        if(Platform.isIOS) {
          cv.cvtColor(obj, cv.COLOR_GRAY2BGRA, dst: obj);
        } else {
          cv.cvtColor(obj, cv.COLOR_GRAY2BGR, dst: obj);
          cv.cvtColor(obj, cv.COLOR_BGR2YUV_I420, dst: obj);
        }

        images.add(
            InputImage.fromBytes(bytes: Uint8List.fromList(obj.data), metadata: InputImageMetadata(
                size: Size(image.width.roundToDouble(), image.height.roundToDouble()),
                rotation: InputImageRotation.rotation0deg,
                format: Platform.isIOS ? InputImageFormat.bgra8888 : InputImageFormat.yuv_420_888,
                bytesPerRow: obj.step
            ))
        );
      }

      _runOCR(images);
      lastOCR = DateTime.now();
    }

    cv.drawKeyPoints(frame, kp.$1, frame, green, cv.DrawMatchesFlag.DEFAULT);

    var out = _produceFrame(frame);
    _updateFrame(out);
    return;
  }
}
