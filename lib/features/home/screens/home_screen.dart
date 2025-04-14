import 'package:flutter/material.dart';
import 'package:mobile/features/home/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:mobile/features/auth/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.userDetail;

    void _setScreen(String identifier) async {}

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Çıkış Yap',
            onPressed: () {
              context.read<AuthProvider>().logout();
            },
          ),
        ],
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null) ...[
              Text('Hoşgeldin, ${user.fullName ?? user.email}'),
              Text('Roller: ${user.roles.join(', ')}'),
              const SizedBox(height: 20),
            ] else if (authProvider.isLoading) ...[
              const CircularProgressIndicator(),
              const Text('Kullanıcı bilgileri yükleniyor...'),
            ] else ...[
              const Text('Kullanıcı bilgileri alınamadı.'),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthProvider>().fetchUserDetails();
                },
                child: const Text('Tekrar Dene'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
