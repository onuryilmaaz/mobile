import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/features/auth/providers/auth_provider.dart'; // Yolu düzeltin
import 'package:mobile/shared/widgets/loading_indicator.dart'; // Yolu düzeltin

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthProvider'dan kullanıcı detaylarını izle
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.userDetail;
    final isLoading = authProvider.isLoading; // Genel yüklenme durumu

    return Scaffold(
      appBar: AppBar(title: const Text('Profilim')),
      body: Center(
        child:
            isLoading &&
                    user ==
                        null // Eğer yükleniyor ve kullanıcı yoksa
                ? const LoadingIndicator()
                : user != null
                ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Tam Ad'),
                        subtitle: Text(user.fullName ?? 'Belirtilmemiş'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('Email'),
                        subtitle: Text(user.email ?? 'Belirtilmemiş'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.security),
                        title: const Text('Roller'),
                        subtitle: Text(
                          user.roles.isEmpty
                              ? 'Rol Yok'
                              : user.roles.join(', '),
                        ), // Rolleri birleştir
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(
                          user.isActive ? Icons.cancel : Icons.check_circle,
                          color: user.isActive ? Colors.red : Colors.green,
                        ),
                        title: const Text('Hesap Durumu'),
                        subtitle: Text(user.isActive ? 'Pasif' : 'Aktif'),
                      ),
                      const Divider(),
                      // İsterseniz başka bilgiler veya düzenleme butonu eklenebilir
                    ],
                  ),
                )
                : Center(
                  // Kullanıcı null ise ve yüklenmiyorsa hata mesajı
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Kullanıcı bilgileri yüklenemedi.'),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Detayları tekrar çekmeyi dene
                          context.read<AuthProvider>().fetchUserDetails();
                        },
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
