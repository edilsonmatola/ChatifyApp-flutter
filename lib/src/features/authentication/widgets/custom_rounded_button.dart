import 'package:flutter/material.dart';

import '../../../core/constants/constants_export.dart';

class CustomRoundedButtonWidget extends StatelessWidget {
  const CustomRoundedButtonWidget({
    Key? key,
    required this.name,
    required this.width,
    required this.height,
    required this.onPress,
  }) : super(key: key);

  final String name;
  final double height;
  final double width;
  final VoidCallback onPress;

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
        onPressed: onPress,
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
