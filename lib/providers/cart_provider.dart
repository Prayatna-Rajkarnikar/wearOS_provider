import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  List<Product> _items = [];
  final String _cartKey = "cached_cart";
  final _watch  = WatchConnectivity();

  List<Product> get items => _items;

  CartProvider() {
    loadCartItems();
  }

  void addToCart(Product product) {
    _items.add(product);
    saveCartItems();
    notifyListeners();
    sendCartSummaryToWatch(_items.length, totalPrice);
  }

  void removeFromCart(Product product) {
    _items.remove(product);
    saveCartItems();
    notifyListeners();
    sendCartSummaryToWatch(_items.length, totalPrice);
  }

  Future<void> saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = _items.map((item) => item.toJson()).toList();
    await prefs.setString(_cartKey, json.encode(cartJson));
  }

  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString(_cartKey);

    if (cartData != null) {
      final List<dynamic> jsonList = json.decode(cartData);
      _items = jsonList.map((json) => Product.fromJson(json)).toList();
      notifyListeners();
    }
    sendCartSummaryToWatch(_items.length, totalPrice);

  }

  void sendCartSummaryToWatch(int totalItems, double totalPrice){
    final summary = {
      "totalItems": totalItems,
      "totalPrice": totalPrice
    };
    
    _watch.sendMessage(summary);
  }

  int get itemCount => _items.length;
  double get totalPrice{
    double total =0;
    for (var item in _items) {
      total = total + item.price;
    }
    return total;
  }
}