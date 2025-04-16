import 'package:app_provider/providers/cart_summary_provider.dart';
import 'package:app_provider/screens/wear_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:is_wear/is_wear.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/product_list_screen.dart';

late final bool isWear;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  isWear = (await IsWear().check()) ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CartSummaryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      debugShowCheckedModeBanner: false,
      home:   isWear? WearSummaryScreen() : ProductListScreen(),
    );
  }
}