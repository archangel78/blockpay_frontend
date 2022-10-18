import 'dart:ui';

import 'package:blockpay_frontend/home_page/components/invite_components/invite_section.dart';
import 'package:blockpay_frontend/home_page/components/more_options/more_options.dart';

import 'separator.dart';
import 'package:flutter/material.dart';
import 'user_components/load_more.dart';
import 'cash_components/cash_utils.dart';
import 'user_components/userDetails.dart';
import 'header_components/header_widget.dart';
import 'header_components/people_header.dart';
import 'header_components/account_header.dart';
import 'header_components/scroll_handle.dart';
import 'header_components/more_options_header.dart';
import 'package:blockpay_frontend/home_page/components/quick_access_components/quick_access_components.dart';

class BlockPayHome extends StatefulWidget {
  @override
  _BlockPayHomeState createState() => _BlockPayHomeState();
}

class _BlockPayHomeState extends State<BlockPayHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 18, 6, 92),
        child: Stack(
          children: [
            HeaderWidget(),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 110, right: 110, top: 100),
                  child: Container(
                    child: Image.asset(
                      "assets/images/blockpaylogo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                QuickAccess(),
              ],
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.66,
              minChildSize: 0.6,
              builder:
                  (BuildContext context, ScrollController myScrollController) {
                return ListView.builder(
                  controller: myScrollController,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 12),
                          ScrollHandle(),
                          SizedBox(height: 20),
                          PeopleHeader(),
                          SizedBox(height: 20),
                          LoadMore(),
                          SizedBox(height: 30),
                          Separator(),
                          SizedBox(height: 30),
                          MoreHeader(),
                          SizedBox(
                            height: 20,
                          ),
                          MoreOptions(),
                          SizedBox(height: 25),
                          Separator(),
                          SizedBox(
                            height: 20,
                          ),
                          AccountHeader(),
                          SizedBox(height: 30),
                          CashUtils(),
                          SizedBox(height: 30),
                          InviteSection(),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
