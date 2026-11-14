import 'package:flutter/material.dart';
import '../widgets/profile_menu_item.dart';
import '../l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String userPhone;
  final AppLanguage language;
  final ThemeMode themeMode;
  final Function(AppLanguage) onLanguageChanged;
  final Function(ThemeMode) onThemeChanged;
  final VoidCallback onLogout;
  final Function(String, String)? onUpdateProfile;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.language,
    required this.themeMode,
    required this.onLanguageChanged,
    required this.onThemeChanged,
    required this.onLogout,
    this.onUpdateProfile,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _name;
  late String _phone;

  @override
  void initState() {
    super.initState();
    _name = widget.userName;
    _phone = widget.userPhone;
  }

  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: _name);
    final phoneController = TextEditingController(text: _phone);
    final l10n = AppLocalizations(widget.language);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.get('profile')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: l10n.get('nameHint')),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: l10n.get('phoneHint')),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Bekor qilish'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _name = nameController.text;
                _phone = phoneController.text;
              });
              if (widget.onUpdateProfile != null) {
                widget.onUpdateProfile!(_name, _phone);
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profil muvaffaqiyatli yangilandi!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
            child: const Text('Saqlash'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations(widget.language);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.get('language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<AppLanguage>(
              title: const Text('O\'zbekcha'),
              value: AppLanguage.uz,
              groupValue: widget.language,
              onChanged: (val) {
                if (val != null) {
                  widget.onLanguageChanged(val);
                  Navigator.pop(ctx);
                }
              },
            ),
            RadioListTile<AppLanguage>(
              title: const Text('Русский'),
              value: AppLanguage.ru,
              groupValue: widget.language,
              onChanged: (val) {
                if (val != null) {
                  widget.onLanguageChanged(val);
                  Navigator.pop(ctx);
                }
              },
            ),
            RadioListTile<AppLanguage>(
              title: const Text('English'),
              value: AppLanguage.en,
              groupValue: widget.language,
              onChanged: (val) {
                if (val != null) {
                  widget.onLanguageChanged(val);
                  Navigator.pop(ctx);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    final l10n = AppLocalizations(widget.language);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.get('settings')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(l10n.get('lightTheme')),
              value: ThemeMode.light,
              groupValue: widget.themeMode,
              onChanged: (val) {
                if (val != null) {
                  widget.onThemeChanged(val);
                  Navigator.pop(ctx);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.get('darkTheme')),
              value: ThemeMode.dark,
              groupValue: widget.themeMode,
              onChanged: (val) {
                if (val != null) {
                  widget.onThemeChanged(val);
                  Navigator.pop(ctx);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.get('systemTheme')),
              value: ThemeMode.system,
              groupValue: widget.themeMode,
              onChanged: (val) {
                if (val != null) {
                  widget.onThemeChanged(val);
                  Navigator.pop(ctx);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showOrdersHistory(BuildContext context) {
    final l10n = AppLocalizations(widget.language);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.get('ordersHistory'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.local_shipping, color: Colors.green),
              title: const Text('Buyurtma #1024'),
              subtitle: const Text('Qizil Olma, Banan • 37,000 so\'m'),
              trailing: const Chip(label: Text('Yetkazildi', style: TextStyle(color: Colors.white, fontSize: 12)), backgroundColor: Colors.green),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showAddresses(BuildContext context) {
    final l10n = AppLocalizations(widget.language);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.get('deliveryAddresses')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.green),
              title: const Text('Asosiy manzil'),
              subtitle: Text(l10n.get('address')),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethods(BuildContext context) {
    final l10n = AppLocalizations(widget.language);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.get('paymentMethods')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            ListTile(
              leading: Icon(Icons.credit_card, color: Colors.indigo),
              title: Text('UzCard / Humo'),
              subtitle: Text('•••• 4589'),
            ),
            ListTile(
              leading: Icon(Icons.money, color: Colors.green),
              title: Text('Naqd pul'),
              subtitle: Text('Yetkazib berilganda to\'lov'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSupport(BuildContext context) {
    final l10n = AppLocalizations(widget.language);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.get('support')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Savollar va takliflar uchun biz bilan bog\'laning:'),
            SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.green),
              title: Text('+998 71 200-00-00'),
            ),
            ListTile(
              leading: Icon(Icons.telegram, color: Colors.blue),
              title: Text('@MevaMarketSupport'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
            child: const Text('Yopish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations(widget.language);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.get('profile'), style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.green.shade100,
                        child: Icon(Icons.person, size: 55, color: Colors.green.shade700),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () => _showEditProfileDialog(context),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              shape: BoxShape.circle,
                              border: Border.all(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.edit, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _phone,
                    style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.history_rounded,
                    title: l10n.get('ordersHistory'),
                    onTap: () => _showOrdersHistory(context),
                  ),
                  ProfileMenuItem(
                    icon: Icons.location_on_outlined,
                    title: l10n.get('deliveryAddresses'),
                    onTap: () => _showAddresses(context),
                  ),
                  ProfileMenuItem(
                    icon: Icons.payment_rounded,
                    title: l10n.get('paymentMethods'),
                    onTap: () => _showPaymentMethods(context),
                  ),
                  ProfileMenuItem(
                    icon: Icons.language_rounded,
                    title: l10n.get('language'),
                    onTap: () => _showLanguageDialog(context),
                  ),
                  ProfileMenuItem(
                    icon: Icons.brightness_6_rounded,
                    title: l10n.get('settings'),
                    onTap: () => _showThemeDialog(context),
                  ),
                  ProfileMenuItem(
                    icon: Icons.support_agent_rounded,
                    title: l10n.get('support'),
                    onTap: () => _showSupport(context),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: widget.onLogout,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade400,
                      side: BorderSide(color: Colors.red.shade200),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.logout_rounded),
                    label: Text(l10n.get('logout'), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
