import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainContainerScreen extends StatefulWidget {
  final String userName;
  final String userPhone;
  final VoidCallback onLogout;

  const MainContainerScreen({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.onLogout,
  });

  @override
  State<MainContainerScreen> createState() => _MainContainerScreenState();
}

class _MainContainerScreenState extends State<MainContainerScreen> {
  int _currentIndex = 0;
  final List<CartItem> _cartItems = [];

  void _addToCart(Product product, {int quantity = 1}) {
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
                  const Text(
                    'Savatga qo’shildi! ✓',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                  ),
                  Text(
                    '${product.name} ($quantity ${product.unit})',
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
          label: 'Savat',
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
    final List<Widget> screens = [
      HomeScreen(onAddToCart: _addToCart),
      CartScreen(
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
              title: const Text('Buyurtma qabul qilindi! 🎉'),
              content: const Text('Tez orada kurerimiz siz bilan bog’lanadi va mevalar yetkazib beriladi.'),
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
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Market',
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
            label: 'Savat',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
