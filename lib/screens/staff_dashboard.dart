import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app_1/screens/manage_menu_items.dart';
import 'package:flutter_app_1/screens/view_orders.dart';
import 'package:flutter_app_1/screens/view_payments.dart';

class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          title: Text(
            'canteen_staff_dashboard'.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red, // 🔴 Red AppBar
          actions: [
            PopupMenuButton<Locale>(
              icon: const Icon(Icons.language, color: Colors.white),
              onSelected: (Locale locale) {
                context.setLocale(locale);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                const PopupMenuItem(
                  value: Locale('hi'),
                  child: Text('हिन्दी'),
                ),
                const PopupMenuItem(
                  value: Locale('te'),
                  child: Text('తెలుగు'),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'welcome_staff'.tr(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            _buildCard(
              icon: Icons.edit_note,
              title: 'manage_menu_items'.tr(),
              context: context,
              destination: const ManageMenuItemsPage(),
            ),
            const SizedBox(height: 20),
            _buildCard(
              icon: Icons.receipt_long,
              title: 'view_orders'.tr(),
              context: context,
              destination: ViewOrdersPage(),
            ),
            const SizedBox(height: 20),
            _buildCard(
              icon: Icons.payments,
              title: 'view_payments'.tr(),
              context: context,
              destination: const ViewPaymentsPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required BuildContext context,
    required Widget destination,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.grey.shade400,
      color: Colors.grey.shade100,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        leading: Icon(icon, size: 30, color: Colors.red),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
      ),
    );
  }
}
