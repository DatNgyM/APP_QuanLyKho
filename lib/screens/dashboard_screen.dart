import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/inventory_provider.dart';
import '../providers/language_provider.dart';
import '../services/supabase_service.dart';
import '../services/local_mockup_service.dart';
import '../utils/app_localizations.dart';
import '../widgets/metric_card.dart';
import '../widgets/recent_activity_card.dart';
import '../widgets/quick_action_button.dart';
import 'add_product_screen.dart';
import 'reports_screen.dart';
import 'inventory_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> _recentActivities = [];
  bool _isLoadingActivities = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// 🎯 Khởi tạo data - Dùng LOCAL MOCKUP
  Future<void> _initializeData() async {
    debugPrint('🚀 Dashboard: Initialize với LOCAL MOCKUP data...');
    
    // Load data (InventoryProvider sẽ tự động dùng local mockup nếu Supabase lỗi)
    final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
    await inventoryProvider.refresh();
    
    // Load activities
    await _loadRecentActivities();
    
    debugPrint('✅ Dashboard initialized successfully!');
  }

  Future<void> _loadRecentActivities() async {
    setState(() {
      _isLoadingActivities = true;
    });

    try {
      // Thử load từ Supabase trước
      final activities = await SupabaseService().getRecentActivities(limit: 5);
      if (mounted) {
        setState(() {
          _recentActivities = activities;
        });
      }
      debugPrint('✅ Loaded ${activities.length} activities from Supabase');
    } catch (e) {
      debugPrint('⚠️ Error loading activities from Supabase: $e');
      debugPrint('📦 Using LOCAL MOCKUP activities instead...');
      
      // Nếu lỗi, dùng LOCAL MOCKUP ACTIVITIES
      if (mounted) {
        setState(() {
          _recentActivities = LocalMockupService.getLocalMockActivities();
        });
      }
      debugPrint('✅ Loaded ${_recentActivities.length} LOCAL mockup activities');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingActivities = false;
        });
      }
    }
  }

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
            icon: const Icon(Icons.refresh),
            onPressed: () {
              inventoryProvider.refresh();
              _loadRecentActivities();
            },
            tooltip: 'Refresh / Làm mới',
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => languageProvider.toggleLanguage(),
            tooltip: languageProvider.currentLanguageName,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await inventoryProvider.refresh();
          await _loadRecentActivities();
        },
        child: SingleChildScrollView(
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
                    value:
                        '\$${inventoryProvider.totalValue.toStringAsFixed(0)}',
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

              // Hiển thị activities từ Supabase
              _isLoadingActivities
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _recentActivities.isEmpty
                      ? Card(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.inbox,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No recent activities / Chưa có hoạt động nào',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : RecentActivityCard(
                          activities: _recentActivities
                              .map((activity) => RecentActivity(
                                    title: activity['title'] ?? 'Activity',
                                    subtitle: activity['subtitle'] ?? '',
                                    time: _formatTime(activity['created_at']),
                                    icon: _getIconForActionType(
                                        activity['action_type']),
                                    color: _getColorForActionType(
                                        activity['action_type']),
                                  ))
                              .toList(),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForActionType(String? actionType) {
    switch (actionType) {
      case 'add':
        return Icons.add_circle;
      case 'update':
        return Icons.edit;
      case 'delete':
        return Icons.delete;
      case 'low_stock_alert':
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  Color _getColorForActionType(String? actionType) {
    switch (actionType) {
      case 'add':
        return Colors.green;
      case 'update':
        return Colors.blue;
      case 'delete':
        return Colors.red;
      case 'low_stock_alert':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return 'Unknown';

    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} minutes ago / ${difference.inMinutes} phút trước';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hours ago / ${difference.inHours} giờ trước';
      } else {
        return '${difference.inDays} days ago / ${difference.inDays} ngày trước';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  void _showLowStockAlert(BuildContext context,
      InventoryProvider inventoryProvider, AppLocalizations l10n) {
    final lowStockProducts = inventoryProvider.products
        .where((product) => product.quantity <= product.minimumQuantity)
        .toList();

    if (lowStockProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
        title: const Text('Low Stock Alert / Cảnh báo hàng sắp hết'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: lowStockProducts.length,
            itemBuilder: (context, index) {
              final product = lowStockProducts[index];
              return ListTile(
                leading: const Icon(
                  Icons.warning,
                  color: Colors.orange,
                ),
                title: Text(product.name),
                subtitle: Text(
                    '${product.quantity} left / còn lại (Min: ${product.minimumQuantity})'),
                trailing: Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
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
            child: const Text('Close / Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const InventoryScreen(),
                ),
              );
            },
            child: const Text('View Inventory / Xem kho'),
          ),
        ],
      ),
    );
  }
}
