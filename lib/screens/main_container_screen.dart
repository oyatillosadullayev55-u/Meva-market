import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../l10n/app_localizations.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainContainerScreen extends StatefulWidget {
  final String userName;
  final String userPhone;
  final AppLanguage language;
  final ThemeMode themeMode;
  final Function(AppLanguage) onLanguageChanged;
  final Function(ThemeMode) onThemeChanged;
  final VoidCallback onLogout;

  const MainContainerScreen({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.language,
    required this.themeMode,
    required this.onLanguageChanged,
    required this.onThemeChanged,
    required this.onLogout,
  });

  @override
  State<MainContainerScreen> createState() => _MainContainerScreenState();
}

class _MainContainerScreenState extends State<MainContainerScreen> {
  int _currentIndex = 0;
  final List<CartItem> _cartItems = [];

  void _addToCart(Product product, {int quantity = 1}) {
    final l10n = AppLocalizations(widget.language);
    setState(() {
      final index = _cartItems.indexWhere((item) => item.product.id == product.id);
      if (index >= 0) {
        _cartItems[index].quantity += quantity;
      } else {
        _cartItems.add(CartItem(product: product, quantity: quantity));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_bag, color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.get('addedToCart'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                  ),
                  Text(
                    '${l10n.get(product.nameKey)} ($quantity ${product.unit == 'kg' ? l10n.get('unitKg') : l10n.get('unitDona')})',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: l10n.get('cart'),
          textColor: Colors.amberAccent,
          onPressed: () {
            setState(() {
              _currentIndex = 1;
            });
          },
        ),
        backgroundColor: Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _updateCartQuantity(String productId, int delta) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item.product.id == productId);
      if (index >= 0) {
        _cartItems[index].quantity += delta;
        if (_cartItems[index].quantity <= 0) {
          _cartItems.removeAt(index);
        }
      }
    });
  }

  void _removeCartItem(String productId) {
    setState(() {
      _cartItems.removeWhere((item) => item.product.id == productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations(widget.language);

    final List<Widget> screens = [
      HomeScreen(language: widget.language, onAddToCart: _addToCart),
      CartScreen(
        language: widget.language,
        cartItems: _cartItems,
        onUpdateQuantity: _updateCartQuantity,
        onRemoveItem: _removeCartItem,
        onCheckout: () {
          setState(() {
            _cartItems.clear();
          });
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(l10n.get('orderSuccess')),
              content: Text(l10n.get('orderSuccessDesc')),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      ),
      ProfileScreen(
        userName: widget.userName,
        userPhone: widget.userPhone,
        language: widget.language,
        themeMode: widget.themeMode,
        onLanguageChanged: widget.onLanguageChanged,
        onThemeChanged: widget.onThemeChanged,
        onLogout: widget.onLogout,
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.storefront_outlined),
            selectedIcon: const Icon(Icons.storefront),
            label: l10n.get('market'),
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: _cartItems.isNotEmpty,
              label: Text(_cartItems.fold(0, (sum, item) => sum + item.quantity).toString()),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: _cartItems.isNotEmpty,
              label: Text(_cartItems.fold(0, (sum, item) => sum + item.quantity).toString()),
              child: const Icon(Icons.shopping_cart),
            ),
            label: l10n.get('cart'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.get('profile'),
          ),
        ],
      ),
    );
  }
}
