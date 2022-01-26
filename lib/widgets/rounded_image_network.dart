// packages
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class RoundedImageNetwork extends StatelessWidget {
  const RoundedImageNetwork({
    Key? key,
    required this.imagePath,
    required this.size,
  }) : super(key: key);

  final String imagePath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(
          Radius.circular(size),
        ),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            imagePath,
          ),
        ),
      ),
    );
  }
}

// TODO: Colocar um icon de camera no profile screen

class RoundedImageFile extends StatelessWidget {
  const RoundedImageFile({
    Key? key,
    required this.image,
    required this.size,
  }) : super(key: key);

  final PlatformFile? image;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(
          Radius.circular(size),
        ),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(
            File(
              image?.path as String,
            ),
          ),
        ),
      ),
    );
  }
}

// * Active or Not Icon
class RoundedIMageNetworkWithStatusIndicator extends RoundedImageNetwork {
  final bool isActive;

  const RoundedIMageNetworkWithStatusIndicator({
    required Key? key,
    required String imagePath,
    required double size,
    required this.isActive,
  }) : super(key: key, imagePath: imagePath, size: size);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      clipBehavior: Clip.none,
      children: [
        super.build(context),
        Container(
          height: size * .20,
          width: size * .20,
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(size),
          ),
        ),
      ],
    );
  }
}
