import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final roleController = TextEditingController();

    Future<void> registerUser() async {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final role = roleController.text.trim();

      try {
        // Insert data ke Supabase
        final response = await Supabase.instance.client.from('users').insert({
          'email': email,
          'password': password,
          'role': role,
          'created_at': DateTime.now().toIso8601String(),
        });

        // Anggap berhasil jika tidak ada exception
        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          Navigator.pop(context); // Kembali ke halaman login
        }
      } catch (e) {
        // Tampilkan pesan error jika ada exception
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: roleController,
              decoration:
                  const InputDecoration(labelText: 'Role (pemilik/pencari)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerUser,
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterScreen()),
                );
              },
              child: const Text("Sudah mempunyai akun? silahkan login"),
            ),
          ],
        ),
      ),
    );
  }
}
