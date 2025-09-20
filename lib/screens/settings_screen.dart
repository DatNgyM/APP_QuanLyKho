import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_localizations.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        authProvider.userName?.substring(0, 1).toUpperCase() ??
                            'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authProvider.userName ?? 'User / Người dùng',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            authProvider.userEmail ?? 'user@example.com',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.7),
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // TODO: Navigate to profile edit
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.3, end: 0),

            const SizedBox(height: 24),

            // App Settings
            Text(
              'App Settings / Cài đặt ứng dụng',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            )
                .animate(delay: 100.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),

            const SizedBox(height: 16),

            // Language Setting
            Card(
              child: ListTile(
                leading: const Icon(Icons.language),
                title: Text(l10n.language),
                subtitle: Text(languageProvider.currentLanguageName),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => languageProvider.toggleLanguage(),
              ),
            )
                .animate(delay: 200.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),

            const SizedBox(height: 8),

            // Theme Setting
            Card(
              child: ListTile(
                leading: const Icon(Icons.palette),
                title: Text(l10n.theme),
                subtitle: Text(themeProvider.currentThemeName),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => themeProvider.toggleTheme(),
              ),
            )
                .animate(delay: 300.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),

            const SizedBox(height: 24),

            // App Information
            Text(
              'App Information / Thông tin ứng dụng',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            )
                .animate(delay: 400.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),

            const SizedBox(height: 16),

            // Notifications
            Card(
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(l10n.notifications),
                subtitle: const Text(
                  'Manage notifications / Quản lý thông báo',
                ),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement notification toggle
                  },
                ),
              ),
            )
                .animate(delay: 500.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),

            const SizedBox(height: 8),

            // Help
            Card(
              child: ListTile(
                leading: const Icon(Icons.help),
                title: Text(l10n.help),
                subtitle: const Text(
                  'Get help and support / Nhận trợ giúp và hỗ trợ',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Navigate to help screen
                },
              ),
            )
                .animate(delay: 600.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),

            const SizedBox(height: 8),

            // About
            Card(
              child: ListTile(
                leading: const Icon(Icons.info),
                title: Text(l10n.about),
                subtitle: Text('${l10n.version} 1.0.0'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showAboutDialog(context, l10n);
                },
              ),
            )
                .animate(delay: 700.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),

            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(context, l10n, authProvider),
                icon: const Icon(Icons.logout),
                label: Text(l10n.logout),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            )
                .animate(delay: 800.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations l10n) {
    showAboutDialog(
      context: context,
      applicationName: l10n.appTitle,
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.inventory_2,
        size: 48,
        color: Color(0xFF2E7D32),
      ),
      children: [
        const Text(
          'A modern inventory management app with bilingual support.\n\n'
          'Ứng dụng quản lý kho hàng hiện đại với hỗ trợ song ngữ.\n\n'
          'Features / Tính năng:\n'
          '• Product Management / Quản lý sản phẩm\n'
          '• Inventory Tracking / Theo dõi kho hàng\n'
          '• Reports & Analytics / Báo cáo và phân tích\n'
          '• Bilingual Support / Hỗ trợ song ngữ\n'
          '• Modern UI Design / Thiết kế giao diện hiện đại',
        ),
      ],
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    AppLocalizations l10n,
    AuthProvider authProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: const Text(
          'Are you sure you want to logout? / Bạn có chắc chắn muốn đăng xuất?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
}
