import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CircularLoading extends StatelessWidget {
  CircularLoading({this.color, this.width, this.height});

  Color color;
  double width;
  double height;

  @override
  Widget build(BuildContext context) {
    if (color == null) {
      color = Colors.white;
    }
    if (width == null) {
      width = 60.0;
    }
    if (height == null) {
      height = 60.0;
    }

    return Center(
      child: Container(
        width: width,
        height: height,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}
