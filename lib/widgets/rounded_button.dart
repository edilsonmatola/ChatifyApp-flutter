import 'package:chatifyapp/constants/constants.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.name,
    required this.width,
    required this.height,
    required this.onPress,
  }) : super(key: key);

  final String name;
  final double height;
  final double width;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height * .25),
        color: AppColors.appPrimaryIconColor,
      ),
      width: width,
      height: height,
      child: TextButton(
        onPressed: () => onPress(),
        child: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
