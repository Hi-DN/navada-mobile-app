// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {

  bool _isDeniedVisible = false;
  int _currentCategoryIndex = 0;
  final CarouselController _carouselController = CarouselController();

  bool get isDeniedVisible => _isDeniedVisible;
  int get currentCategoryIndex => _currentCategoryIndex;
  CarouselController get carouselController => _carouselController;
  
  void setDeniedVisible(bool newValue) {
    _isDeniedVisible = newValue;
    notifyListeners();
  }

  void setCurrentCategoryIndex(int newValue) {
    _currentCategoryIndex = newValue;
    notifyListeners();
  }
}
