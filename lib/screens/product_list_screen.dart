import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context);
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text(
                    '${cart.itemCount}',
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              )
            ],
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () => products.fetchProducts(),
        child: ListView.builder(
          itemCount: products.products.length,
          itemBuilder: (ctx, index) {
            final Product product = products.products[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: Image.network(product.thumbnail, width: 60, fit: BoxFit.cover),
                title: Text(product.title),
                subtitle: Text("Rs ${product.price}"),
                trailing: ElevatedButton(
                  onPressed: () {
                    cart.addToCart(product);
                  },
                  child: const Text("Add to Cart"),
                ),
              ),
            );
          },
        ),
      ),

    );
  }
}