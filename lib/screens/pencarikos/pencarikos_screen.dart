import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PencariKosScreen extends StatefulWidget {
  final String email;

  const PencariKosScreen({super.key, required this.email});

  @override
  State<PencariKosScreen> createState() => _PencariKosScreenState();
}

class _PencariKosScreenState extends State<PencariKosScreen> {
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
      const Center(child: Text('Halaman Favorit')),
      const Center(child: Text('Halaman Pengaturan')),
      const Center(child: Text('Halaman Pengaturan')),
      Center(child: Text('Home Pencari Kos untuk ${userData?['email'] ?? ''}')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencari Kos'),
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
            icon: const Icon(Icons.favorite),
            title: const Text('Favorit'),
            activeColor: Colors.pink,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.settings),
            title: const Text('Pengaturan'),
            activeColor: Colors.green,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Profile'),
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
