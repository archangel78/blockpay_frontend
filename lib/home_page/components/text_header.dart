import 'package:flutter/material.dart';

class TextHeader extends StatelessWidget {
  String headerValue;
  TextHeader({required this.headerValue});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25),
      child: Row(
        children: [
          Text(
            headerValue,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
