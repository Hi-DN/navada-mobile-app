import 'package:flutter/cupertino.dart';

class AppInfoViewModel extends ChangeNotifier {
  static const int maxFAQNum = 10;

  List<bool> _isFAQAnswerShown = List.generate(maxFAQNum, (index) => false);
  List<bool> get isFAQAnswerShown => _isFAQAnswerShown;

  toggleAnswerView(int index) {
    _isFAQAnswerShown[index] = !_isFAQAnswerShown[index];
    notifyListeners();
  }
}
