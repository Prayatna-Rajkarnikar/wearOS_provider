import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final String _cacheKey = "cached_products";
  final String _ivKey = "iv_key"; // new
  final _secretKey = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');

  List<Product> _products = [];
  List<Product> get products => _products;

  encrypt.Encrypter get _encrypter => encrypt.Encrypter(encrypt.AES(_secretKey));

  Future<void> fetchProducts() async {
    final prefs = await SharedPreferences.getInstance();

    // Load stored IV or create a new one
    encrypt.IV iv;
    final ivString = prefs.getString(_ivKey);
    if (ivString != null) {
      iv = encrypt.IV.fromBase64(ivString);
    } else {
      iv = encrypt.IV.fromSecureRandom(16);
      await prefs.setString(_ivKey, iv.base64);
    }

    // Try decrypting from cache
    final encryptedData = prefs.getString(_cacheKey);
    if (encryptedData != null) {
      try {
        final decrypted = _encrypter.decrypt64(encryptedData, iv: iv);
        final List<dynamic> productList = jsonDecode(decrypted);
        _products = productList.map((json) => Product.fromJson(json)).toList();
        notifyListeners();
        return;
      } catch (e) {
        await prefs.remove(_cacheKey);
        await prefs.remove(_ivKey);
      }
    }

    // Fetch from API
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/products'));
      if (response.statusCode == 200) {
        final List productsJson = json.decode(response.body)['products'];
        _products = productsJson.map((json) => Product.fromJson(json)).toList();
        notifyListeners();

        // Encrypt and store
        final encrypted = _encrypter.encrypt(json.encode(productsJson), iv: iv);
        await prefs.setString(_cacheKey, encrypted.base64);
        print("SEncrypted and saved to local storage");
      } else {
        throw Exception('Failed to load products from API');
      }
    } catch (e) {
      print('Network error: $e');
    }
  }
}
