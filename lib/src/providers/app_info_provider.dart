import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/faq/faq_list_model.dart';
import 'package:navada_mobile_app/src/models/faq/faq_service.dart';

class AppInfoProvider extends ChangeNotifier {
  final FAQService _faqService = FAQService();

  List<FAQ>? _faqList;
  List<FAQ>? get faqList => _faqList;

  fetchFAQList() async {
    FAQListModel model = await _faqService.getFAQList();

    _faqList = model.dataList;
    notifyListeners();
  }
}
