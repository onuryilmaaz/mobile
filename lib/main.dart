import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/features/auth/providers/auth_provider.dart';
import 'package:mobile/features/user/providers/user_provider.dart';
// import 'package:mobile/features/auth/screens/login_screen.dart';
import 'package:mobile/features/home/screens/home_screen.dart';
import 'package:mobile/shared/widgets/loading_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter .NET API Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (!authProvider.isInitialized) {
      return const Scaffold(body: LoadingIndicator());
    }

    return HomeScreen();

    // if (authProvider.isAuthenticated) {
    //   return const HomeScreen();
    // } else {
    //   return const LoginScreen();
    // }
  }
}
