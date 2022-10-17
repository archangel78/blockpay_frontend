import 'dart:io';

import 'package:hive/hive.dart';

class HiveManager {
  static var sessionBox;
  static initialize() async {
    var path = Directory.current.path;
    Hive.init(path);
    var box = await Hive.openBox('sessionBox');
    sessionBox = box;
  }

  static putSecure(String key, String value) async {
    await sessionBox.put(key, value);
  }

  static getSecure(String key) async {
    return sessionBox.get(key);
  }
}
