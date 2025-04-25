// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile/features/auth/screens/login_screen.dart';
import 'package:mobile/features/auth/screens/register_screen.dart';
import 'package:mobile/features/home/widgets/drawer.dart';
import 'package:mobile/features/poll/screens/poll_screen.dart';
import 'package:provider/provider.dart';
import 'package:mobile/features/auth/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.userDetail;

    // ignore: no_leading_underscores_for_local_identifiers
    void _setScreen(String identifier) async {}

    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('POLLING-APP'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.login),
                      title: Text('Login'),
                      onTap: () {
                        Navigator.pop(context); // Menü kapansın
                        Future.delayed(Duration.zero, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.add),
                      title: Text('Register'),
                      onTap: () {
                        Navigator.pop(context); // Menü kapansın
                        Future.delayed(Duration.zero, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Çıkış Yap'),
                      onTap: () {
                        Navigator.pop(context); // Menüyü kapat
                        context
                            .read<AuthProvider>()
                            .logout(); // Logout fonksiyonunu çağır
                      },
                    ),
                  ),
                ],
          ),
        ],
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null) ...[
              Text(
                'Hoşgeldin, ${user.fullName}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Roller: ${user.roles.join(', ')}',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PollScreen()),
                    );
                  },
                  child: const Text('Ankete katıl'),
                ),
              ),
            ] else if (authProvider.isLoading) ...[
              const CircularProgressIndicator(),
              const Text('Kullanıcı bilgileri yükleniyor...'),
            ] else ...[
              const Text(
                'Hızlı, kolay ve güvenilir anketler oluşturun ve katılın.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PollScreen()),
                        );
                      },
                      child: const Text('Ankete katıl'),
                    ),
                  ),
                  if (user == null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                          context.read<AuthProvider>().fetchUserDetails();
                        },
                        child: const Text('Giriş Yap'),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
