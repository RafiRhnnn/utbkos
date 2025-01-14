import 'package:flutter/material.dart';

class PencariKosScreen extends StatelessWidget {
  const PencariKosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencari Kos'),
      ),
      body: const Center(
        child: Text('Welcome to Pencari Kos Dashboard!'),
      ),
    );
  }
}
