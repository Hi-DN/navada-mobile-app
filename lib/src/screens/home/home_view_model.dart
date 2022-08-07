// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {

  bool _isDeniedVisible = false;

  bool get isDeniedVisible => _isDeniedVisible;
  
  void setDeniedVisible(bool newValue) {
    _isDeniedVisible = newValue;
    notifyListeners();
  }
}
