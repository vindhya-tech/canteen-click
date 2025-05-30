import 'package:flutter/material.dart';

class ViewPaymentsPage extends StatelessWidget {
  const ViewPaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Payments')),
      body: const Center(
        child: Text(
          'Here you can verify and track all payments received.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
