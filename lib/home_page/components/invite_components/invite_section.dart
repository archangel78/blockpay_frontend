import 'package:flutter/material.dart';

class InviteSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(color: Colors.blue[50]),
      child: Padding(
        padding: EdgeInsets.only(left: 25, top: 30),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Invite your Contact's",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,

                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Container(
                  height: 35,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 1,
                      color: Color.fromARGB(255, 155, 180, 229),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Invite now",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
