import 'package:flutter/material.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:wear_plus/wear_plus.dart';

class WearSummaryScreen extends StatefulWidget {
  const WearSummaryScreen({super.key});

  @override
  State<WearSummaryScreen> createState() => _WearSummaryScreenState();
}

class _WearSummaryScreenState extends State<WearSummaryScreen> {

  final _watch = WatchConnectivity();
  int totalItems = 0;
  double totalPrice = 0.0;

  void initState() {
    super.initState();
    _watch.messageStream.listen((message) {
      if (message.containsKey('totalItems') && message.containsKey('totalPrice')) {
        setState(() {
          totalItems = message['totalItems'];
          totalPrice = double.tryParse(message['totalPrice'].toString()) ?? 0.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AmbientMode(builder: (context, mode, child) => Scaffold(appBar: AppBar(title: Center(child: Text("Products"),),), body: Column(children: [Text("Items: $totalItems"), Text("Total Price: $totalPrice")],)),);
  }
}
