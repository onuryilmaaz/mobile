import 'package:flutter/material.dart';
import 'package:mobile/features/auth/providers/auth_provider.dart';
import 'package:mobile/features/home/screens/home_screen.dart';
import 'package:mobile/features/user/screens/profile_screen.dart';
import 'package:mobile/features/user/screens/user_list_screen.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.userDetail;
    //final user = authProvider.userDetail;
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color.fromARGB(255, 5, 111, 101), Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    const Icon(Icons.poll, size: 48, color: Colors.white),
                    const SizedBox(width: 18),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${user != null ? user.fullName : "Poll Apps"}',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge!.copyWith(color: Colors.white),
                        ),
                        Text(
                          '${user?.roles.join(', ') ?? ""}',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout),
                          tooltip: 'Çıkış Yap',
                          onPressed: () {
                            context.read<AuthProvider>().logout();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, size: 26, color: Colors.black),
            title: Text(
              "Ana Sayfa",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          if (authProvider.isAdmin)
            ListTile(
              leading: const Icon(Icons.group, size: 26, color: Colors.black),
              title: Text(
                "Kullanıcı Listesi",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserListScreen(),
                  ),
                );
              },
            ),
          if (authProvider.isAdmin)
            ListTile(
              leading: const Icon(
                Icons.account_circle_outlined,
                size: 26,
                color: Colors.black,
              ),
              title: Text(
                "Profilim",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
          if (authProvider.isAdmin)
            ListTile(
              leading: const Icon(Icons.create, size: 26, color: Colors.black),
              title: Text(
                "Anket Oluştur",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
          if (authProvider.isAdmin)
            ListTile(
              leading: const Icon(Icons.list, size: 26, color: Colors.black),
              title: Text(
                "Anket Listesi",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
          if (authProvider.isAdmin)
            ListTile(
              leading: const Icon(
                Icons.category,
                size: 26,
                color: Colors.black,
              ),
              title: Text(
                "Kategori Oluştur",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
          if (authProvider.isAdmin)
            ListTile(
              leading: const Icon(Icons.poll, size: 26, color: Colors.black),
              title: Text(
                "Anket Özeti",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 230,
              ), // biraz yukarı kaldırmak istersen
              child: IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Çıkış Yap',
                onPressed: () {
                  context.read<AuthProvider>().logout();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
