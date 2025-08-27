import 'package:flutter/material.dart';
import '../../../core/themes/app_theme.dart';

class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AppDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  'SF Institute',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Tuition Fee Manager',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            index: 0,
            icon: Icons.dashboard,
            title: 'Dashboard',
          ),
          _buildDrawerItem(
            context,
            index: 1,
            icon: Icons.class_,
            title: 'Classes',
          ),
          _buildDrawerItem(
            context,
            index: 2,
            icon: Icons.people,
            title: 'Students',
          ),
          _buildDrawerItem(
            context,
            index: 3,
            icon: Icons.payment,
            title: 'Payments',
          ),
          _buildDrawerItem(
            context,
            index: 4,
            icon: Icons.person,
            title: 'Profile',
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            index: -1, // Special index for settings
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              // TODO: Navigate to settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon')),
              );
            },
          ),
          _buildDrawerItem(
            context,
            index: -2, // Special index for logout
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              // Logout logic
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String title,
    Function()? onTap,
  }) {
    final isSelected = index == selectedIndex;

    return ListTile(
      leading: Icon(icon, color: isSelected ? AppTheme.primaryColor : null),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppTheme.primaryColor : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      selected: isSelected,
      onTap:
          onTap ??
          () {
            if (index >= 0) {
              // Only trigger for valid screen indices
              onItemSelected(index);
              Navigator.pop(context); // Close the drawer
            }
          },
    );
  }
}
