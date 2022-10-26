import 'package:blockpay_frontend/home_page/components/block_pay_home.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dashed_circle/dashed_circle.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:blockpay_frontend/model/userModel.dart';

class PeopleDetails extends StatelessWidget {
  List<ContactsValues> contacts;
  ScrollController scrollController;
  PeopleDetails({required this.contacts, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 190,
          width: double.infinity,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemCount: 8,
            controller: scrollController,
            itemBuilder: (context, i) {
              return GridTile(
                child: Column(
                  children: [
                    CircleAvatar(
                      child: Text(
                        contacts[i].initals,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      radius: 27,
                      backgroundColor: contacts[i].color,
                    ),
                    SizedBox(height: 2),
                    Text(
                      contacts[i].name,
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(left: 17),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.38,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      3,
                      (index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Column(
                            children: [
                              DashedCircle(
                                gapSize: 4,
                                dashes: 0,
                                color: Colors.grey,
                                child: Padding(
                                  padding: EdgeInsets.all(3),
                                  child: CircleAvatar(
                                    child: Text(
                                      contacts[index+8].initals,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    radius: 27,
                                    backgroundColor: contacts[index+8].color,
                                  ),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                contacts[index+8].name,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              size: 50,
                              color: Colors.black,
                            ),
                            backgroundColor: Colors.grey[300],
                          ),
                          Text(
                            "Show More",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
