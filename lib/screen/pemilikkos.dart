import 'package:flutter/material.dart';

class PemilikKosScreen extends StatelessWidget {
  const PemilikKosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemilik Kos'),
      ),
      body: const Center(
        child: Text('Welcome to Pemilik Kos Dashboard!'),
      ),
    );
  }
}
