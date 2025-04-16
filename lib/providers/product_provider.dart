import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final String _cacheKey = "cached_products";
  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cachedRecipes');

    if (cachedData != null) {
      final List<dynamic> productList = jsonDecode(cachedData);
      _products=  productList.map((json) => Product.fromJson(json)).toList();
    }

    final response = await http.get(Uri.parse('https://dummyjson.com/products'));
    if (response.statusCode == 200) {
      final List productsJson = json.decode(response.body)['products'];
      _products = productsJson.map((json) => Product.fromJson(json)).toList();

      await prefs.setString(_cacheKey, json.encode(productsJson));
    } else {
      throw Exception('Failed to load products');
    }
  }
}