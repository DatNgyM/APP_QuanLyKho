import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/inventory_provider.dart';
import '../providers/language_provider.dart';
import '../utils/app_localizations.dart';
import '../widgets/metric_card.dart';
import '../widgets/recent_activity_card.dart';
import '../widgets/quick_action_button.dart';
import 'add_product_screen.dart';
import 'reports_screen.dart';
import 'inventory_screen.dart';

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
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            // Metrics Cards
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4, // Adjusted for smaller cards
              children: [
                MetricCard(
                  title: l10n.totalProducts,
                  value: inventoryProvider.totalProducts.toString(),
                  icon: Icons.inventory_2,
                  color: Colors.blue,
                  trend: '+12%',
                ),
                MetricCard(
                  title: l10n.lowStock,
                  value: inventoryProvider.lowStockCount.toString(),
                  icon: Icons.warning,
                  color: Colors.orange,
                  trend: '-5%',
                ),
                MetricCard(
                  title: l10n.outOfStock,
                  value: inventoryProvider.outOfStockCount.toString(),
                  icon: Icons.error,
                  color: Colors.red,
                  trend: '+2%',
                ),
                MetricCard(
                  title: 'Total Value / Tổng giá trị',
                  value: '\$${inventoryProvider.totalValue.toStringAsFixed(0)}',
                  icon: Icons.attach_money,
                  color: Colors.green,
                  trend: '+8%',
                ),
              ],
            ),

            // Quick Actions
            Text(
              'Quick Actions / Hành động nhanh',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddProductScreen(),
                      ),
                    );
                  },
                ),
                QuickActionButton(
                  title: 'Low Stock / Hàng sắp hết',
                  icon: Icons.warning,
                  color: Colors.orange,
                  onTap: () {
                    _showLowStockAlert(context, inventoryProvider, l10n);
                  },
                ),
                QuickActionButton(
                  title: l10n.reports,
                  icon: Icons.analytics,
                  color: Colors.teal,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ReportsScreen(),
                      ),
                    );
                  },
                ),
                QuickActionButton(
                  title: 'Export / Xuất báo cáo',
                  icon: Icons.download,
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ReportsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Recent Activity
            Text(
              l10n.recentActivity,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

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
            ),
          ],
        ),
      ),
    );
  }

  void _showLowStockAlert(BuildContext context,
      InventoryProvider inventoryProvider, AppLocalizations l10n) {
    final lowStockProducts = inventoryProvider.products
        .where((product) => product.quantity <= product.minimumQuantity)
        .toList();

    if (lowStockProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('No low stock products / Không có sản phẩm sắp hết hàng'),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Low Stock Alert / Cảnh báo hàng sắp hết'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: lowStockProducts.length,
            itemBuilder: (context, index) {
              final product = lowStockProducts[index];
              return ListTile(
                leading: Icon(
                  Icons.warning,
                  color: Colors.orange,
                ),
                title: Text(product.name),
                subtitle: Text(
                    '${product.quantity} left / còn lại (Min: ${product.minimumQuantity})'),
                trailing: Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close / Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to inventory screen with low stock filter
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const InventoryScreen(),
                ),
              );
            },
            child: Text('View Inventory / Xem kho'),
          ),
        ],
      ),
    );
  }
}
