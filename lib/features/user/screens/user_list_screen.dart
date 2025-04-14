import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/features/user/providers/user_provider.dart'; // Yolu düzeltin
import 'package:mobile/features/user/models/user_detail.dart'; // Yolu düzeltin
import 'package:mobile/shared/widgets/loading_indicator.dart'; // Yolu düzeltin

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    // Ekran açıldığında kullanıcıları çekmeyi tetikle (sadece bir kere)
    // WidgetsBinding.instance.addPostFrameCallback ile build bittikten sonra çağrılır
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider'a erişim için context'in hazır olması gerekir
      if (mounted) {
        // Eğer widget hala ağaçtaysa
        context.read<UserProvider>().fetchUsers();
      }
    });
  }

  Future<void> _refreshUsers() async {
    // Pull-to-refresh için kullanıcıları tekrar çek
    await context.read<UserProvider>().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    // UserProvider'daki değişiklikleri dinle
    final userProvider = context.watch<UserProvider>();
    final users = userProvider.users;
    final isLoading = userProvider.isLoading;
    final errorMessage = userProvider.errorMessage;

    return Scaffold(
      appBar: AppBar(title: const Text('Kullanıcı Yönetimi')),
      body: RefreshIndicator(
        onRefresh: _refreshUsers, // Pull-to-refresh tetikleyicisi
        child:
            isLoading &&
                    users
                        .isEmpty // Başlangıçta yükleniyorsa
                ? const LoadingIndicator()
                : errorMessage != null
                ? Center(
                  // Hata varsa göster
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Hata: $errorMessage',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                )
                : users.isEmpty
                ? const Center(
                  child: Text('Gösterilecek kullanıcı bulunamadı.'),
                ) // Kullanıcı yoksa
                : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return UserListItem(
                      user: user,
                      // Durum değiştirme fonksiyonunu UserListItem'a geç
                      onStatusChanged: (newStatus) async {
                        final success = await context
                            .read<UserProvider>()
                            .toggleUserStatus(user.id, user.isActive);
                        if (!success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${user.fullName ?? user.email} durumu güncellenemedi.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
      ),
    );
  }
}

// Kullanıcı listesi öğesi için ayrı bir widget oluşturmak daha temizdir
class UserListItem extends StatelessWidget {
  final UserDetail user;
  final Function(bool)
  onStatusChanged; // Durum değiştirildiğinde çağrılacak fonksiyon

  const UserListItem({
    super.key,
    required this.user,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Provider'ı burada tekrar okumaya gerek yok, isLoading'i direkt alabiliriz.
    final isLoading = context.watch<UserProvider>().isLoading;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        title: Text(user.fullName ?? 'İsim Yok'),
        subtitle: Text(user.email ?? 'Email Yok'),
        trailing:
            isLoading // Eğer provider genel olarak yükleniyorsa Switch yerine indicator gösterilebilir
                ? const SizedBox(
                  width: 50,
                  height: 30,
                  child: Center(child: LoadingIndicator()),
                )
                : Tooltip(
                  message:
                      user.isActive ? 'Hesabı Pasif Yap' : 'Hesabı Aktif Yap',
                  child: Switch(
                    value: user.isActive,
                    onChanged: (newValue) {
                      // Burada direkt API çağrısı yapmak yerine,
                      // UserListScreen'e iletilen callback'i çağırıyoruz.
                      onStatusChanged(newValue);
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                ),
        leading: CircleAvatar(
          // Kullanıcının baş harfi veya profil resmi
          child: Text(
            user.fullName?.isNotEmpty == true
                ? user.fullName![0].toUpperCase()
                : '?',
          ),
        ),
      ),
    );
  }
}
