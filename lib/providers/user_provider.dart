import 'package:fluffy_mvp/models/login_model.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  Login? _login;

  Login? get login => _login;

  void setLogin(Login login) {
    _login = login;
    notifyListeners();
  }
}
