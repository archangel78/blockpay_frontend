import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';

class Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dash(
      dashColor: Color.fromRGBO(128, 128, 128, 1),
      dashLength: 3,
      direction: Axis.horizontal,
      length: MediaQuery.of(context).size.width - 60,
      dashThickness: 2,
      dashGap: 5,
    );
  }
}
