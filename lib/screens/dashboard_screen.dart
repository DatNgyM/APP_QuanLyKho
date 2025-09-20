import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/inventory_provider.dart';
import '../providers/language_provider.dart';
import '../utils/app_localizations.dart';
import '../widgets/metric_card.dart';
import '../widgets/recent_activity_card.dart';
import '../widgets/quick_action_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => languageProvider.toggleLanguage(),
            tooltip: languageProvider.currentLanguageName,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Message
            Text(
              '${l10n.welcome}, ${inventoryProvider.totalProducts} ${l10n.products.toLowerCase()}!',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.3, end: 0),

            const SizedBox(height: 24),

            // Metrics Cards
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.8,
              children: [
                MetricCard(
                  title: l10n.totalProducts,
                  value: inventoryProvider.totalProducts.toString(),
                  icon: Icons.inventory_2,
                  color: Colors.blue,
                  trend: '+12%',
                ).animate(delay: 200.ms).fadeIn(duration: 600.ms).scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                    ),
                MetricCard(
                  title: l10n.lowStock,
                  value: inventoryProvider.lowStockCount.toString(),
                  icon: Icons.warning,
                  color: Colors.orange,
                  trend: '-5%',
                ).animate(delay: 300.ms).fadeIn(duration: 600.ms).scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                    ),
                MetricCard(
                  title: l10n.outOfStock,
                  value: inventoryProvider.outOfStockCount.toString(),
                  icon: Icons.error,
                  color: Colors.red,
                  trend: '+2%',
                ).animate(delay: 400.ms).fadeIn(duration: 600.ms).scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                    ),
                MetricCard(
                  title: 'Total Value / Tổng giá trị',
                  value: '\$${inventoryProvider.totalValue.toStringAsFixed(0)}',
                  icon: Icons.attach_money,
                  color: Colors.green,
                  trend: '+8%',
                ).animate(delay: 500.ms).fadeIn(duration: 600.ms).scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                    ),
              ],
            ),

            const SizedBox(height: 32),

            // Quick Actions
            Text(
              'Quick Actions / Hành động nhanh',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            )
                .animate(delay: 600.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),

            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2,
              children: [
                QuickActionButton(
                  title: l10n.addProduct,
                  icon: Icons.add,
                  color: Theme.of(context).primaryColor,
                  onTap: () {
                    // TODO: Navigate to add product screen
                  },
                )
                    .animate(delay: 700.ms)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),
                QuickActionButton(
                  title: 'Scan Barcode / Quét mã vạch',
                  icon: Icons.qr_code_scanner,
                  color: Colors.purple,
                  onTap: () {
                    // TODO: Implement barcode scanning
                  },
                )
                    .animate(delay: 800.ms)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),
                QuickActionButton(
                  title: l10n.reports,
                  icon: Icons.analytics,
                  color: Colors.teal,
                  onTap: () {
                    // TODO: Navigate to reports screen
                  },
                )
                    .animate(delay: 900.ms)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),
                QuickActionButton(
                  title: 'Export / Xuất dữ liệu',
                  icon: Icons.download,
                  color: Colors.indigo,
                  onTap: () {
                    // TODO: Implement data export
                  },
                )
                    .animate(delay: 1000.ms)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),
              ],
            ),

            const SizedBox(height: 32),

            // Recent Activity
            Text(
              l10n.recentActivity,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            )
                .animate(delay: 1100.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),

            const SizedBox(height: 16),

            RecentActivityCard(
              activities: [
                RecentActivity(
                  title: 'Product Added / Sản phẩm đã thêm',
                  subtitle: 'iPhone 15 Pro - 25 units',
                  time: '2 hours ago / 2 giờ trước',
                  icon: Icons.add_circle,
                  color: Colors.green,
                ),
                RecentActivity(
                  title: 'Low Stock Alert / Cảnh báo hàng sắp hết',
                  subtitle: 'Samsung Galaxy S24 - 3 units left',
                  time: '4 hours ago / 4 giờ trước',
                  icon: Icons.warning,
                  color: Colors.orange,
                ),
                RecentActivity(
                  title: 'Product Updated / Sản phẩm đã cập nhật',
                  subtitle: 'Nike Air Max 270 - Price changed',
                  time: '1 day ago / 1 ngày trước',
                  icon: Icons.edit,
                  color: Colors.blue,
                ),
              ],
            )
                .animate(delay: 1200.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }
}
