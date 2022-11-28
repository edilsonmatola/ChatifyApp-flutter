// Packages
import 'package:flutter/material.dart';

class CustomTopBar extends StatefulWidget {
  const CustomTopBar(
    this._barTitle, {
    Key? key,
    this.primaryAction,
    this.secondaryAction,
    this.fontSize = 35,
  }) : super(key: key);

  final String _barTitle;
  final Widget? primaryAction;
  final Widget? secondaryAction;
  final double? fontSize;

  @override
  State<CustomTopBar> createState() => _CustomTopBarState();
}

class _CustomTopBarState extends State<CustomTopBar> {
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
          if (widget.secondaryAction != null) widget.secondaryAction!,
          Text(
            widget._barTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          if (widget.primaryAction != null) widget.primaryAction!,
        ],
      ),
    );
  }
}
