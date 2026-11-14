import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';
import '../l10n/app_localizations.dart';
import '../screens/login_screen.dart';
import '../screens/main_container_screen.dart';
import '../screens/product_detail_screen.dart';

class AppRouter {
  static GoRouter createRouter({
    required bool isLoggedIn,
    required String userName,
    required String userPhone,
    required AppLanguage language,
    required ThemeMode themeMode,
    required Function(String, String) onLogin,
    required VoidCallback onLogout,
    required Function(AppLanguage) onLanguageChanged,
    required Function(ThemeMode) onThemeChanged,
    required Function(Product, {int quantity}) onAddToCart,
  }) {
    return GoRouter(
      initialLocation: isLoggedIn ? '/' : '/login',
      redirect: (context, state) {
        final loggingIn = state.uri.path == '/login';
        if (!isLoggedIn && !loggingIn) return '/login';
        if (isLoggedIn && loggingIn) return '/';
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginScreen(
            language: language,
            onLoginSuccess: (name, phone) {
              onLogin(name, phone);
              context.go('/');
            },
          ),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => MainContainerScreen(
            userName: userName,
            userPhone: userPhone,
            language: language,
            themeMode: themeMode,
            onLanguageChanged: onLanguageChanged,
            onThemeChanged: onThemeChanged,
            onLogout: () {
              onLogout();
              context.go('/login');
            },
          ),
        ),
        GoRoute(
          path: '/product-detail',
          builder: (context, state) {
            final product = state.extra as Product;
            return ProductDetailScreen(
              product: product,
              language: language,
              onAddToCart: onAddToCart,
            );
          },
        ),
      ],
    );
  }
}
