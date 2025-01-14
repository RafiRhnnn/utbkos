import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screen/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url:
        'https://oxnyeqwreirlaxroipyh.supabase.co', // Ganti dengan URL Supabase Anda
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94bnllcXdyZWlybGF4cm9pcHloIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY4NTg0MjksImV4cCI6MjA1MjQzNDQyOX0.JOSXribR1kjxLr3oe4nhErHqBWeLlf9MCRBbnfF5m80', // Ganti dengan Key Supabase Anda
  );

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
