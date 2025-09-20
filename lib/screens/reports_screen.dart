import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/inventory_provider.dart';
import '../utils/app_localizations.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reports)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.8,
              children: [
                _buildSummaryCard(
                  context,
                  'Total Products / Tổng sản phẩm',
                  inventoryProvider.totalProducts.toString(),
                  Icons.inventory_2,
                  Colors.blue,
                ).animate(delay: 100.ms).fadeIn(duration: 600.ms).scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                    ),
                _buildSummaryCard(
                  context,
                  'Low Stock / Hàng sắp hết',
                  inventoryProvider.lowStockCount.toString(),
                  Icons.warning,
                  Colors.orange,
                ).animate(delay: 200.ms).fadeIn(duration: 600.ms).scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                    ),
                _buildSummaryCard(
                  context,
                  'Out of Stock / Hết hàng',
                  inventoryProvider.outOfStockCount.toString(),
                  Icons.error,
                  Colors.red,
                ).animate(delay: 300.ms).fadeIn(duration: 600.ms).scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                    ),
                _buildSummaryCard(
                  context,
                  'Total Value / Tổng giá trị',
                  '\$${inventoryProvider.totalValue.toStringAsFixed(0)}',
                  Icons.attach_money,
                  Colors.green,
                ).animate(delay: 400.ms).fadeIn(duration: 600.ms).scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                    ),
              ],
            ),

            const SizedBox(height: 32),

            // Low Stock Products
            Text(
              'Low Stock Products / Sản phẩm sắp hết hàng',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            )
                .animate(delay: 500.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),

            const SizedBox(height: 16),

            if (inventoryProvider.getLowStockProducts().isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle,
                        size: 48, color: Colors.green),
                    const SizedBox(height: 12),
                    Text(
                      'All products are well stocked! / Tất cả sản phẩm đều có đủ hàng!',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
                  .animate(delay: 600.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0)
            else
              ...inventoryProvider.getLowStockProducts().map((product) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.withOpacity(0.1),
                      child: const Icon(
                        Icons.warning,
                        color: Colors.orange,
                      ),
                    ),
                    title: Text(product.name),
                    subtitle: Text(
                      '${product.quantity} units left / ${product.quantity} đơn vị còn lại',
                    ),
                    trailing: Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                )
                    .animate(
                      delay: Duration(
                        milliseconds: 600 +
                            (inventoryProvider.getLowStockProducts().indexOf(
                                      product,
                                    ) *
                                100),
                      ),
                    )
                    .fadeIn(duration: 600.ms)
                    .slideX(begin: -0.3, end: 0);
              }),

            const SizedBox(height: 32),

            // Export Options
            Text(
              'Export Options / Tùy chọn xuất dữ liệu',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            )
                .animate(delay: 800.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement CSV export
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'CSV export feature coming soon / Tính năng xuất CSV sắp ra mắt',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.table_chart),
                    label: const Text('Export CSV / Xuất CSV'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement PDF export
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'PDF export feature coming soon / Tính năng xuất PDF sắp ra mắt',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Export PDF / Xuất PDF'),
                  ),
                ),
              ],
            )
                .animate(delay: 900.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
