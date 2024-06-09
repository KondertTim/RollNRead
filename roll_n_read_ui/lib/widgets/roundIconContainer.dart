import 'package:flutter/cupertino.dart';

class RoundIconContainer extends StatelessWidget {

  final IconData icon;
  final Color color;
  final Color iconColor;


  const RoundIconContainer({
    super.key,
    required this.icon,
    required this.color,
    required this.iconColor,
});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
    child: Icon(icon, color: iconColor,),

  );

}
