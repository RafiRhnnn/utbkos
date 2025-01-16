import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'tambah_screen.dart'; // Import halaman TambahScreen

class PemilikKosScreen extends StatefulWidget {
  final String email;

  const PemilikKosScreen({super.key, required this.email});

  @override
  State<PemilikKosScreen> createState() => _PemilikKosScreenState();
}

class _PemilikKosScreenState extends State<PemilikKosScreen> {
  late Future<Map<String, dynamic>?> _userData;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _userData = fetchUserData();
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('email, role')
          .eq('email', widget.email) // Menggunakan email yang diteruskan
          .maybeSingle();

      if (response == null) {
        debugPrint('No data found for email: ${widget.email}');
        return null;
      }

      return response;
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      return null;
    }
  }

  List<Widget> _buildPages(Map<String, dynamic>? userData) {
    return [
      Center(child: Text('Halaman Home untuk ${userData?['email'] ?? ''}')),
      Center(child: Text('Halaman Statistik')),
      Center(child: Text('Halaman tambah')),
      Center(child: Text('Halaman profile')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Pemilik Kos'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Error loading profile data'));
          }

          final userData = snapshot.data!;
          return _buildPages(userData)[_currentIndex];
        },
      ),
      floatingActionButton: _currentIndex ==
              2 // Tampilkan hanya di halaman Pengaturan
          ? FloatingActionButton(
              onPressed: () {
                // Navigasi ke TambahScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TambahScreen()),
                );
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.blue,
            )
          : null,
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _currentIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
            activeColor: Colors.blue,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.bar_chart),
            title: const Text('Statistik'),
            activeColor: Colors.green,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.add),
            title: const Text('Tambah'),
            activeColor: Colors.red,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Profile'),
            activeColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
