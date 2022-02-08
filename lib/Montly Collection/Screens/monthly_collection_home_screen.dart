import 'package:flutter/material.dart';

class MonthlyCollectionScreen extends StatelessWidget {
  const MonthlyCollectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade400,
        title: const Text('Monthly Collection'),
        centerTitle: true,
      ),
    );
  }
}
