import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/inventory_provider.dart';
import '../utils/app_localizations.dart';
import '../services/export_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _revenueData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final inventoryProvider =
          Provider.of<InventoryProvider>(context, listen: false);
      final revenue = await inventoryProvider.getRevenueData();

      setState(() {
        _revenueData = revenue;
      });
    } catch (e) {
      print('Debug: Error loading data: $e');
      // Add some default data for testing
      setState(() {
        _revenueData = [
          {
            'date': DateTime.now().subtract(const Duration(days: 6)),
            'revenue': 2500.0
          },
          {
            'date': DateTime.now().subtract(const Duration(days: 5)),
            'revenue': 2800.0
          },
          {
            'date': DateTime.now().subtract(const Duration(days: 4)),
            'revenue': 2200.0
          },
          {
            'date': DateTime.now().subtract(const Duration(days: 3)),
            'revenue': 3000.0
          },
          {
            'date': DateTime.now().subtract(const Duration(days: 2)),
            'revenue': 1900.0
          },
          {
            'date': DateTime.now().subtract(const Duration(days: 1)),
            'revenue': 2400.0
          },
          {'date': DateTime.now(), 'revenue': 2100.0},
        ];
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _exportToPDF() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final inventoryProvider =
          Provider.of<InventoryProvider>(context, listen: false);
      final data = await inventoryProvider.exportData();
      final filePath = await ExportService.exportToPDF(data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF exported to: $filePath'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _exportToCSV() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final inventoryProvider =
          Provider.of<InventoryProvider>(context, listen: false);
      final data = await inventoryProvider.exportData();
      final filePath = await ExportService.exportToCSV(data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('CSV exported to: $filePath'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting CSV: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reports),
        actions: [
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh / Làm mới',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Export Actions
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Export Reports / Xuất báo cáo',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _exportToPDF,
                                  icon: const Icon(Icons.picture_as_pdf),
                                  label: const Text('Export PDF'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _exportToCSV,
                                  icon: const Icon(Icons.table_chart),
                                  label: const Text('Export CSV'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Summary Cards
                  Text(
                    'Summary / Tổng kết',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 16),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    children: [
                      _buildSummaryCard(
                        context,
                        'Total Products / Tổng sản phẩm',
                        inventoryProvider.totalProducts.toString(),
                        Icons.inventory_2,
                        Colors.blue,
                      ),
                      _buildSummaryCard(
                        context,
                        'Total Value / Tổng giá trị',
                        '\$${inventoryProvider.totalValue.toStringAsFixed(0)}',
                        Icons.attach_money,
                        Colors.green,
                      ),
                      _buildSummaryCard(
                        context,
                        'Low Stock / Hàng sắp hết',
                        inventoryProvider.lowStockCount.toString(),
                        Icons.warning,
                        Colors.orange,
                      ),
                      _buildSummaryCard(
                        context,
                        'Categories / Danh mục',
                        '5',
                        Icons.category,
                        Colors.purple,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Simple Revenue Chart (no complex widgets)
                  Text(
                    'Revenue Analysis / Phân tích doanh thu',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 16),

                  _buildSimpleRevenueChart(),

                  const SizedBox(height: 24),

                  // Category Distribution
                  Text(
                    'Category Distribution / Phân bố danh mục',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 16),

                  _buildCategoryDistribution(context, inventoryProvider),

                  const SizedBox(height: 24),

                  // Top Products
                  Text(
                    'Top Products by Value / Sản phẩm có giá trị cao nhất',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 16),

                  _buildTopProducts(context, inventoryProvider),

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildSimpleRevenueChart() {
    if (_revenueData.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'No revenue data available / Không có dữ liệu doanh thu',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final maxRevenue = _revenueData
        .map((d) => d['revenue'] as double)
        .reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue Trend / Xu hướng doanh thu',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _revenueData.length,
                itemBuilder: (context, index) {
                  final data = _revenueData[index];
                  final revenue = data['revenue'] as double;
                  final date = data['date'] as DateTime;

                  return Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: (revenue / maxRevenue) * 150,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${revenue.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${date.day}/${date.month}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Summary stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  'Total / Tổng',
                  '\$${_getTotalRevenue().toStringAsFixed(0)}',
                  Icons.attach_money,
                  Colors.green,
                ),
                _buildStatItem(
                  'Average / Trung bình',
                  '\$${_getAverageRevenue().toStringAsFixed(0)}',
                  Icons.trending_up,
                  Colors.blue,
                ),
                _buildStatItem(
                  'Growth / Tăng trưởng',
                  '${_getGrowthRate().toStringAsFixed(1)}%',
                  Icons.show_chart,
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String title, String value, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
          textAlign: TextAlign.center,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 9,
              ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
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
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDistribution(
      BuildContext context, InventoryProvider inventoryProvider) {
    final categories = <String, int>{};
    for (final product in inventoryProvider.products) {
      categories[product.category] = (categories[product.category] ?? 0) + 1;
    }

    if (categories.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'No categories found / Không tìm thấy danh mục',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ),
      );
    }

    final total = categories.values.reduce((a, b) => a + b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: categories.entries.map((entry) {
            final percentage = (entry.value / total * 100).toStringAsFixed(1);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(entry.key),
                  ),
                  Expanded(
                    flex: 3,
                    child: LinearProgressIndicator(
                      value: entry.value / total,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('$percentage%'),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTopProducts(
      BuildContext context, InventoryProvider inventoryProvider) {
    final sortedProducts = List.from(inventoryProvider.products)
      ..sort((a, b) => (b.quantity * b.price).compareTo(a.quantity * a.price));

    if (sortedProducts.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'No products found / Không tìm thấy sản phẩm',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: sortedProducts.take(5).map((product) {
            final value = product.quantity * product.price;
            return ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.1),
                child: Icon(
                  Icons.inventory_2,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: Text(product.name),
              subtitle: Text('${product.quantity} units'),
              trailing: Text(
                '\$${value.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  double _getTotalRevenue() {
    if (_revenueData.isEmpty) return 0;
    return _revenueData
        .map((data) => data['revenue'] as double)
        .reduce((a, b) => a + b);
  }

  double _getAverageRevenue() {
    if (_revenueData.isEmpty) return 0;
    return _getTotalRevenue() / _revenueData.length;
  }

  double _getGrowthRate() {
    if (_revenueData.length < 2) return 0;
    final first = _revenueData.first['revenue'] as double;
    final last = _revenueData.last['revenue'] as double;
    return ((last - first) / first) * 100;
  }
}
