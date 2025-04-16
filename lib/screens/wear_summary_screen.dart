import 'package:app_provider/providers/cart_summary_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:wear_plus/wear_plus.dart';

class WearSummaryScreen extends StatefulWidget {
  const WearSummaryScreen({super.key});

  @override
  State<WearSummaryScreen> createState() => _WearSummaryScreenState();
}

class _WearSummaryScreenState extends State<WearSummaryScreen> {

  final _watch = WatchConnectivity();

  void initState() {
    super.initState();
    _watch.messageStream.listen((message) {
      if (message.containsKey('totalItems') && message.containsKey('totalPrice')) {
        final provider = Provider.of<CartSummaryProvider>(context, listen: false);
        provider.updateSummary(
          message['totalItems'],
          double.tryParse(message['totalPrice'].toString()) ?? 0.0,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AmbientMode(builder: (context, mode, child) => 
        Scaffold(
            appBar: AppBar(
              title: Center(child: Text("Products"),
              ),
            ),
            body: Center(
              child: Consumer<CartSummaryProvider>(
                builder: (context, summary, child) => Column(
                  children: [
                    Text("Items: ${summary.totalItems}"),
                    Text("Total Price: Rs ${summary.totalPrice.toStringAsFixed(2)}")
                  ],
                ),
              ),
            )
        ),
    );
  }
}
