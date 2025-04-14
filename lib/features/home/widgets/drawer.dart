import 'package:flutter/material.dart';
import 'package:mobile/features/auth/providers/auth_provider.dart';
import 'package:mobile/features/user/screens/profile_screen.dart';
import 'package:mobile/features/user/screens/user_list_screen.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    //final user = authProvider.userDetail;
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.poll, size: 48, color: Colors.white),
                const SizedBox(width: 18),
                Text(
                  "Poll Apps",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(color: Colors.white),
                ),
              ],
            ),
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

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Çıkış Yap',
                  onPressed: () {
                    context.read<AuthProvider>().logout();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
