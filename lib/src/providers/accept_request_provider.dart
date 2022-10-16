import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/request/request_service.dart';

class AcceptRequestProvider extends ChangeNotifier {

  final RequestService _requestService = RequestService();

  acceptRequest(int requestId) {
    _requestService.acceptRequest(requestId);
  }

  rejectRequest(int requestId) {
    _requestService.rejectRequest(requestId);
  }
}