import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kasut/features/auth/screens/login_screen.dart';
import 'package:kasut/features/profile/screens/edit_profile_screen.dart';
import 'package:kasut/features/auth/services/auth_service.dart';
import 'package:kasut/providers/wishlist_provider.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsOn = true;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Account'),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.pushNamed(context, EditProfileScreen.routeName),
          ),
          _buildDivider(),
          _buildSectionHeader('Preferences'),
          SwitchListTile(
            title: const Text('Notifications'),
            value: _notificationsOn,
            onChanged: (val) => setState(() => _notificationsOn = val),
            secondary: const Icon(Icons.notifications_none),
            activeColor: Colors.black,
          ),
          _buildDivider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(_language),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _selectLanguage,
          ),
          _buildDivider(),
          _buildSectionHeader('Support'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Kasut'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Kasut',
              applicationVersion: '5.0.13',
              applicationLegalese: '© 2024 Kasut',
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDivider() => const Divider(height: 1, indent: 16, endIndent: 16);

  void _selectLanguage() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: const Text('English'), onTap: () => _setLang('English')),
            ListTile(title: const Text('Bahasa Indonesia'), onTap: () => _setLang('Bahasa Indonesia')),
          ],
        ),
      ),
    );
  }

  void _setLang(String lang) {
    setState(() => _language = lang);
    Navigator.pop(context);
  }

  void _logout() {
    // Clear wishlist if provider present
    try {
      Provider.of<WishlistProvider>(context, listen: false).clearWishlist();
    } catch (_) {}
    AuthService.logout();
    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (r) => false);
  }
}
