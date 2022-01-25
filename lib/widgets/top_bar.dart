// Packages
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  TopBar(
    this._barTitle, {
    Key? key,
    this.primaryAction,
    this.secondaryAction,
    this.fontSize,
  }) : super(key: key);

  final String _barTitle;
  final Widget? primaryAction;
  final Widget? secondaryAction;
  double? fontSize = 35;

  late double _deviceWidth;
  late double _deviceHeight;

  @override
  Widget build(BuildContext context) {
    // Responsive layout
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return _buildUI();
  }

  Widget _buildUI() {
    return SizedBox(
      width: _deviceWidth,
      height: _deviceHeight * .10,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (secondaryAction != null) secondaryAction!,
          _titleBar(),
          if (primaryAction != null) primaryAction!,
        ],
      ),
    );
  }

  Widget _titleBar() {
    return Text(
      _barTitle,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
