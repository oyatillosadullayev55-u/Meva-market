import 'package:flutter/material.dart';
import '../widgets/profile_menu_item.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String userPhone;
  final VoidCallback onLogout;
  final Function(String, String)? onUpdateProfile;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.userPhone,
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

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Profilni tahrirlash'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Ism va Familiya'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Telefon raqam'),
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

  void _showOrdersHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Buyurtmalar tarixi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.local_shipping, color: Colors.green),
              title: const Text('Buyurtma #1024'),
              subtitle: const Text('Qizil Olma, Banan • 37,000 so\'m'),
              trailing: const Chip(label: Text('Yetkazildi', style: TextStyle(color: Colors.white, fontSize: 12)), backgroundColor: Colors.green),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.blue),
              title: const Text('Buyurtma #1021'),
              subtitle: const Text('Avakado, Limon • 46,000 so\'m'),
              trailing: const Chip(label: Text('Bajarildi', style: TextStyle(color: Colors.white, fontSize: 12)), backgroundColor: Colors.blue),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showAddresses(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yetkazib berish manzillari'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            ListTile(
              leading: Icon(Icons.location_on, color: Colors.green),
              title: Text('Asosiy manzil'),
              subtitle: Text('Toshkent shahri, Amir Temur ko\'chasi 15-uy'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Yangi manzil qo\'shish oynasi')));
            },
            child: const Text('+ Manzil qo\'shish'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
            child: const Text('Yopish'),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethods(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('To\'lov usullari'),
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

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateModal) {
          bool notifications = true;
          return AlertDialog(
            title: const Text('Sozlamalar'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Bildirishnomalar'),
                  value: notifications,
                  onChanged: (val) {
                    setStateModal(() => notifications = val);
                  },
                ),
                ListTile(
                  title: const Text('Ilova tili'),
                  trailing: const Text('O\'zbekcha', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                  onTap: () {},
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
                child: const Text('Saqlash'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Qo\'llab-quvvatlash xizmati'),
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
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
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
                              border: Border.all(color: Colors.white, width: 2),
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
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _phone,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
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
                    title: 'Buyurtmalar tarixi',
                    onTap: () => _showOrdersHistory(context),
                  ),
                  ProfileMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Yetkazib berish manzillari',
                    onTap: () => _showAddresses(context),
                  ),
                  ProfileMenuItem(
                    icon: Icons.payment_rounded,
                    title: 'To\'lov usullari',
                    onTap: () => _showPaymentMethods(context),
                  ),
                  ProfileMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Sozlamalar',
                    onTap: () => _showSettings(context),
                  ),
                  ProfileMenuItem(
                    icon: Icons.support_agent_rounded,
                    title: 'Qo\'llab-quvvatlash xizmati',
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
                    label: const Text('Hisobdan chiqish', style: TextStyle(fontWeight: FontWeight.bold)),
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
