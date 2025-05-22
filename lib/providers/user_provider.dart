import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _userData;

  Map<String, dynamic>? get userData => _userData;

  String? get username => _userData?['username'];
  String? get firstName => _userData?['first_name'];
  String? get middleName => _userData?['middle_name'];
  String? get lastName => _userData?['last_name'];
  String? get email => _userData?['email'];
  String? get phone => _userData?['phone'];
  String? get dob => _userData?['dob'];
  String? get userId => _userData?['id']?.toString();


  void setUserData(Map<String, dynamic> data) {
    _userData = data;
    notifyListeners();
  }

  void setUsername(String username) {
    _userData ??= {};
    _userData!['username'] = username;
    notifyListeners();
  }

  void setFirstName(String firstName) {
    _userData ??= {};
    _userData!['first_name'] = firstName;
    notifyListeners();
  }

  // You can add other setters similarly if needed

  void clearUserData() {
    _userData = null;
    notifyListeners();
  }
}
