import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screen/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inisialisasi Supabase
    await Supabase.initialize(
      url: 'https://oxnyeqwreirlaxroipyh.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94bnllcXdyZWlybGF4cm9pcHloIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY4NTg0MjksImV4cCI6MjA1MjQzNDQyOX0.JOSXribR1kjxLr3oe4nhErHqBWeLlf9MCRBbnfF5m80', // Ganti dengan Anon Key Supabase Anda
    );
  } catch (e) {
    // Jika terjadi kesalahan saat inisialisasi
    debugPrint('Error initializing Supabase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UtbKos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
