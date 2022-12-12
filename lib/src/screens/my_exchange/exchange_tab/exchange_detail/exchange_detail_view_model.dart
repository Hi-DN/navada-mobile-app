import 'package:flutter/material.dart';

class ExchangeDetailViewModel extends ChangeNotifier {
  ExchangeDetailViewModel(this._isCompleteFeatureActive);
  bool _isCompleteFeatureActive;

  bool _isInitial = true;
  bool _isStarGrey = true;
  bool _hasConfirmedNoRating = false;
  bool _hasConfirmedRating = false;
  double _rating = 0;

  bool get isCompleteFeatureActive => _isCompleteFeatureActive;
  
  bool get isInitial => _isInitial;
  bool get isStarGrey => _isStarGrey;
  bool get hasConfirmedNoRating => _hasConfirmedNoRating;
  bool get hasConfirmedRating => _hasConfirmedRating;
  double get rating => _rating;

  setCompleteFeatureActive(bool val) {
    _isCompleteFeatureActive = val;
    notifyListeners();
  }

  setInitial(bool val) {
    _isInitial = val;
    notifyListeners();
  }

  setStarGrey(bool val) {
    _isStarGrey = val;
    notifyListeners();
  }

  setRating(double rating) {
    _rating = rating;
    setStarGrey(false);
    setConfirmedNoRating(false);
    setConfirmedRating(true);
    notifyListeners();
  }

  setConfirmedNoRating(bool val) {
    setInitial(false);
    _hasConfirmedNoRating = val;
    if(val) {
      setConfirmedRating(false);
      setStarGrey(true);
    }
    notifyListeners();
  }

  setConfirmedRating(bool val) {
    setInitial(false);
    _hasConfirmedRating = val;
    if(val) {
      setConfirmedNoRating(false);
      setStarGrey(false);
    }
    notifyListeners();
  }
}
