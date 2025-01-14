import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'register.dart';
import 'pemilikkos.dart';
import 'pencarikos.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    Future<void> loginUser() async {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      try {
        final response = await Supabase.instance.client
            .from('users')
            .select()
            .eq('email', email)
            .eq('password', password)
            .limit(1)
            .maybeSingle();

        if (response == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Login failed. Incorrect credentials.')),
          );
          return;
        }

        final role = response['role'];
        if (role == 'pemilik') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PemilikKosScreen()),
          );
        } else if (role == 'pencari') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PencariKosScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid role. Please try again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loginUser,
              child: const Text('Login'),
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
              child: const Text("Belum mempunyai akun? sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
