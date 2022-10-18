import 'package:flutter/material.dart';

class QuickAccess extends StatefulWidget {
  @override
  _QuickAccessState createState() => _QuickAccessState();
}

class _QuickAccessState extends State<QuickAccess> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Column(
            children: [
              CircleAvatar(
                child: Icon(
                  Icons.center_focus_weak,
                  color: Color.fromARGB(255, 50, 122, 223),
                  size: 45,
                ),
                backgroundColor: Color.fromARGB(255, 18, 6, 92),
                minRadius: 35.0,
              ),
              Text(
                "Scan",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          Column(
            children: [
              CircleAvatar(
                child: Icon(
                  Icons.people,
                  color: Color.fromARGB(255, 255, 255, 255),
                  size: 45,
                ),
                backgroundColor: Color.fromARGB(255, 18, 6, 92),
                minRadius: 35.0,
              ),
              Text(
                "Send to Contact",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          Column(
            children: [
              CircleAvatar(
                child: Container(
                  child: Image.asset("assets/icons/thunderbolt.png"),
                  height: 38,
                  width: 38,
                ),
                backgroundColor: Color.fromARGB(255, 18, 6, 92),
                minRadius: 35.0,
              ),
              Text(
                "Offline pay",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          Column(
            children: [
              CircleAvatar(
                child: Container(
                  child: Image.asset("assets/icons/history.png"),
                  height: 38,
                  width: 38,
                ),
                backgroundColor: Color.fromARGB(255, 18, 6, 92),
                minRadius: 35.0,
              ),
              Text(
                "History",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }
}
