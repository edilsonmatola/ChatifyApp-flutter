// Packages
import 'package:flutter/material.dart';

class TopBar extends StatefulWidget {
  const TopBar(
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
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
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
          _titleBar(),
          if (widget.primaryAction != null) widget.primaryAction!,
        ],
      ),
    );
  }

  Widget _titleBar() {
    return Text(
      widget._barTitle,
      style: TextStyle(
        color: Colors.white,
        fontSize: widget.fontSize,
        fontWeight: FontWeight.w700,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
