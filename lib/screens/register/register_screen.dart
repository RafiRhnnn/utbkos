import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_snackbar.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final roleController = TextEditingController();

    final authService = AuthService();

    Future<void> registerUser() async {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final role = roleController.text.trim();

      if (email.isEmpty || password.isEmpty || role.isEmpty) {
        CustomSnackbar.show(
          context,
          'Please complete all fields',
        );
        return;
      }

      final errorMessage = await authService.registerUser(
        email: email,
        password: password,
        role: role,
      );

      if (errorMessage != null) {
        CustomSnackbar.show(context, errorMessage);
        return;
      }

      CustomSnackbar.show(
        context,
        'Registration successful!',
        isError: false,
      );
      Navigator.pop(context); // Kembali ke halaman login
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
            CustomTextField(
              controller: emailController,
              label: 'Email',
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: passwordController,
              label: 'Password',
              obscureText: true,
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: roleController.text.isEmpty ? null : roleController.text,
              onChanged: (value) {
                roleController.text = value ?? '';
              },
              items: [
                DropdownMenuItem(
                  value: 'pemilik',
                  child: Text('Pemilik'),
                ),
                DropdownMenuItem(
                  value: 'pencari',
                  child: Text('Pencari'),
                ),
              ],
              decoration: InputDecoration(
                labelText: 'Role (pemilik/pencari)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerUser,
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Kembali ke halaman login
              },
              child: const Text("Sudah mempunyai akun? Silahkan login"),
            ),
          ],
        ),
      ),
    );
  }
}
