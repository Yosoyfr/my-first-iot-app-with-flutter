import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({
    Key? key,
    this.color = const Color(0xFF9672F6),
    this.backgroundColor = const Color(0xFF642FF3),
  }) : super(key: key);

  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color,
        backgroundColor: backgroundColor,
      ),
    );
  }
}
