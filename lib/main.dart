import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'l10n/app_localizations.dart';

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
  AppLanguage _language = AppLanguage.uz;
  ThemeMode _themeMode = ThemeMode.light;

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

  void _changeLanguage(AppLanguage lang) {
    setState(() {
      _language = lang;
    });
  }

  void _changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.createRouter(
      isLoggedIn: _isLoggedIn,
      userName: _userName,
      userPhone: _userPhone,
      language: _language,
      themeMode: _themeMode,
      onLogin: _login,
      onLogout: _logout,
      onLanguageChanged: _changeLanguage,
      onThemeChanged: _changeTheme,
      onAddToCart: (product, {quantity = 1}) {},
    );

    return MaterialApp.router(
      title: 'Meva Market',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          secondary: const Color(0xFFFF8F00),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          secondary: const Color(0xFFFF8F00),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      routerConfig: router,
    );
  }
}
