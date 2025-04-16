import 'package:flutter/cupertino.dart';

class CartSummaryProvider with ChangeNotifier {
  int _totalItems = 0;
  double _totalPrice = 0.0;

  int get totalItems => _totalItems;
  double get totalPrice => _totalPrice;

  void updateSummary(int items, double price) {
    _totalItems = items;
    _totalPrice = price;
    notifyListeners();
  }
}
