import 'package:flutter/material.dart';

// buat nyimpen state user
class UserProvider extends ChangeNotifier {
  int _userId = 0;
  String _username = "";

  int get userId => _userId;
  String get username => _username;

  void setUser(int id, String name) {
    _userId = id;
    _username = name;
    notifyListeners();
  }
}
