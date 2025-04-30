// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile/features/home/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:mobile/features/auth/providers/auth_provider.dart';
import 'package:mobile/features/auth/screens/register_screen.dart';
import 'package:mobile/shared/widgets/loading_indicator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authProvider.errorMessage ?? 'Bilinmeyen bir hata oluştu.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      context.read<AuthProvider>().fetchUserDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    final errorMessage = context.watch<AuthProvider>().errorMessage;

    return Scaffold(
      appBar: AppBar(title: const Text('Giriş Yap')),
      backgroundColor: Colors.teal,
      body: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Giriş Yap",
                      style: TextStyle(color: Colors.teal, fontSize: 28),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      maxLength: 256,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'Geçerli bir email girin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Şifre'),
                      obscureText: true,
                      maxLength: 256,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Şifrenizi girin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    if (errorMessage != null && !isLoading)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    isLoading
                        ? const LoadingIndicator()
                        : ElevatedButton(
                          onPressed: _login,
                          // ignore: sort_child_properties_last
                          child: const Text('Giriş Yap'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal, // Arka plan rengi
                            foregroundColor: Colors.white, // Yazı rengi
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ), // Opsiyonel: buton boyutu
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // Butona yuvarlak köşe
                            ),
                          ),
                        ),
                    TextButton(
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const RegisterScreen(),
                                  ),
                                );
                              },
                      child: const Text('Hesabınız yok mu? Kayıt Olun'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
