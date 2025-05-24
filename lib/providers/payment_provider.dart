import 'package:flutter/material.dart';

class PaymentProvider with ChangeNotifier {
  // Example state (you can add more)
  bool _isPaymentSuccessful = false;

  bool get isPaymentSuccessful => _isPaymentSuccessful;

  void markAsPaid() {
    _isPaymentSuccessful = true;
    notifyListeners();
  }

  void resetPaymentStatus() {
    _isPaymentSuccessful = false;
    notifyListeners();
  }
}
