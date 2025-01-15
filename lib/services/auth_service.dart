import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  /// **Register User**
  /// Mendaftarkan pengguna baru dengan email, password, dan role.
  Future<String?> registerUser({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _client.from('users').insert({
        'email': email,
        'password': password,
        'role': role,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (response != null) {
        return null; // Berhasil tanpa error
      }
      return 'Registration failed. Please try again.';
    } catch (e) {
      return 'Error: $e';
    }
  }

  /// **Login User**
  /// Memeriksa kredensial login (email dan password) dan mengembalikan role pengguna.
  Future<Map<String, dynamic>?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('email', email)
          .eq('password', password)
          .limit(1)
          .maybeSingle();

      if (response == null) {
        return null; // Login gagal
      }
      return response; // Berhasil, mengembalikan data pengguna
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
