import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/main_container_screen.dart';

void main() {
  runApp(const MevaMarketApp());
}

class MevaMarketApp extends StatefulWidget {
  const MevaMarketApp({super.key});

  @override
  State<MevaMarketApp> createState() => _MevaMarketAppState();
}

class _MevaMarketAppState extends State<MevaMarketApp> {
  bool _isLoggedIn = false;
  String _userName = '';
  String _userPhone = '';

  void _login(String name, String phone) {
    setState(() {
      _isLoggedIn = true;
      _userName = name;
      _userPhone = phone;
    });
  }

  void _logout() {
    setState(() {
      _isLoggedIn = false;
      _userName = '';
      _userPhone = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meva Market',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          secondary: const Color(0xFFFF8F00),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: _isLoggedIn
          ? MainContainerScreen(
              userName: _userName,
              userPhone: _userPhone,
              onLogout: _logout,
            )
          : LoginScreen(onLoginSuccess: _login),
    );
  }
}
