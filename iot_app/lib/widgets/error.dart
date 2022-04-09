import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  const Error({
    Key? key,
    required this.text,
    this.color = Colors.black,
  }) : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
    );
  }
}
