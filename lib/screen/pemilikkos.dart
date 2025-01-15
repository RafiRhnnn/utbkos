import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PemilikKosScreen extends StatefulWidget {
  final String email;

  const PemilikKosScreen({super.key, required this.email});

  @override
  State<PemilikKosScreen> createState() => _PemilikKosScreenState();
}

class _PemilikKosScreenState extends State<PemilikKosScreen> {
  late Future<Map<String, dynamic>?> _userData;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemilik Kos'),
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
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email: ${userData['email']}',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  'Role: ${userData['role']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                // Tambahkan tampilan halaman Pemilik Kos di sini
                const Text('Tampilan Pemilik Kos'),
              ],
            ),
          );
        },
      ),
    );
  }
}
