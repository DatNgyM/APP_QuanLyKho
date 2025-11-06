import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/order_provider.dart';
import '../models/order_type.dart';
import '../models/order_status.dart';
import '../widgets/order_card.dart';
import '../widgets/order_summary_card.dart';
import 'order_detail_screen.dart';
import 'create_order_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    
    switch (_tabController.index) {
      case 0: // Tất cả
        orderProvider.setOrderTypeFilter(null);
        break;
      case 1: // Nhập hàng
        orderProvider.setOrderTypeFilter(OrderType.import);
        break;
      case 2: // Xuất hàng
        orderProvider.setOrderTypeFilter(OrderType.export);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Đơn hàng',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.search, size: 20),
                ),
                onPressed: () => _showSearchDialog(context),
                tooltip: 'Tìm kiếm',
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.refresh, size: 20),
                ),
                onPressed: () => orderProvider.refresh(),
                tooltip: 'Làm mới',
              ),
              const SizedBox(width: 8),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Tất cả', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${orderProvider.totalOrders}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('⬇️ Nhập', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green[600],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${orderProvider.importOrdersCount}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('⬆️ Xuất', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange[600],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${orderProvider.exportOrdersCount}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => orderProvider.refresh(),
        child: Column(
          children: [
            // Summary Cards với background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.05),
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OrderSummaryCard(
                      title: 'Tổng đơn',
                      value: '${orderProvider.totalOrders}',
                      icon: Icons.receipt_long_rounded,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OrderSummaryCard(
                      title: 'Chờ xử lý',
                      value: '${orderProvider.pendingOrdersCount}',
                      icon: Icons.schedule_rounded,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OrderSummaryCard(
                      title: 'Hoàn thành',
                      value: '${orderProvider.completedOrdersCount}',
                      icon: Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: -0.2, end: 0, curve: Curves.easeOutCubic),

            // Status Filter Chips với divider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Lọc theo trạng thái',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ).animate().fadeIn(delay: 300.ms),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildFilterChip(context, null, 'Tất cả'),
                      const SizedBox(width: 10),
                      _buildFilterChip(context, OrderStatus.pending, 'Chờ xác nhận'),
                      const SizedBox(width: 10),
                      _buildFilterChip(context, OrderStatus.processing, 'Đang xử lý'),
                      const SizedBox(width: 10),
                      _buildFilterChip(context, OrderStatus.completed, 'Hoàn thành'),
                      const SizedBox(width: 10),
                      _buildFilterChip(context, OrderStatus.cancelled, 'Đã hủy'),
                    ],
                  ),
                ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1, end: 0),
              ],
            ),

            const SizedBox(height: 12),

            // Orders List
            Expanded(
              child: _buildOrdersList(context, orderProvider),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _navigateToCreateOrder(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.add_circle_outline, size: 26),
          label: const Text(
            'Tạo đơn',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      )
          .animate()
          .scale(delay: 800.ms, duration: 400.ms, curve: Curves.elasticOut)
          .shimmer(delay: 1000.ms, duration: 1500.ms),
    );
  }

  Widget _buildFilterChip(BuildContext context, OrderStatus? status, String label) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final isSelected = orderProvider.selectedStatus == status;

    // Màu cho từng loại status
    Color chipColor = Colors.grey;
    if (status == OrderStatus.pending) chipColor = Colors.amber;
    if (status == OrderStatus.processing) chipColor = Colors.blue;
    if (status == OrderStatus.completed) chipColor = Colors.green;
    if (status == OrderStatus.cancelled) chipColor = Colors.red;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[800],
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          orderProvider.setStatusFilter(selected ? status : null);
        },
        selectedColor: status != null ? chipColor : Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.grey[100],
        checkmarkColor: Colors.white,
        elevation: isSelected ? 4 : 1,
        shadowColor: chipColor.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? chipColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, OrderProvider orderProvider) {
    if (orderProvider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải danh sách đơn hàng...'),
          ],
        ),
      );
    }

    if (orderProvider.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon với gradient background
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withOpacity(0.1),
                      Colors.orange.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.cloud_off_outlined,
                  size: 80,
                  color: Theme.of(context).colorScheme.error,
                ),
              )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.elasticOut)
                  .shake(delay: 600.ms, hz: 2, curve: Curves.easeInOut),
              const SizedBox(height: 24),
              Text(
                'Lỗi tải dữ liệu',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  orderProvider.errorMessage ?? 'Đã xảy ra lỗi không xác định',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
              ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.9, 0.9)),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => orderProvider.refresh(),
                icon: const Icon(Icons.refresh_rounded, size: 22),
                label: const Text(
                  'Thử lại',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
              ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.8, 0.8)),
            ],
          ),
        ),
      );
    }

    final orders = orderProvider.orders;

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated empty icon với gradient
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.1),
                    Colors.purple.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.3))
                .shake(duration: 1500.ms, delay: 400.ms, hz: 0.5, curve: Curves.easeInOut),
            const SizedBox(height: 24),
            Text(
              'Chưa có đơn hàng nào',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),
            const SizedBox(height: 12),
            Text(
              'Nhấn nút "Tạo đơn" bên dưới để bắt đầu',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[500],
                  ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),
            const SizedBox(height: 32),
            // Hướng dẫn nhanh
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.arrow_downward, color: Colors.green, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tạo phiếu nhập hàng vào kho',
                          style: TextStyle(color: Colors.grey[700], fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.arrow_upward, color: Colors.orange, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tạo phiếu xuất hàng khỏi kho',
                          style: TextStyle(color: Colors.grey[700], fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.9, 0.9)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          onTap: () => _navigateToOrderDetail(context, order.id),
          onUpdateStatus: () => _showUpdateStatusDialog(context, order),
          onCancel: () => _showCancelConfirmation(context, order),
        ).animate().fadeIn(delay: (index * 50).ms);
      },
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tìm kiếm đơn hàng'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Nhập ID, tên đối tác...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            Provider.of<OrderProvider>(context, listen: false)
                .setSearchQuery(value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<OrderProvider>(context, listen: false)
                  .setSearchQuery('');
              Navigator.pop(context);
            },
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showUpdateStatusDialog(BuildContext context, order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cập nhật trạng thái'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: OrderStatus.values.map((status) {
            return RadioListTile<OrderStatus>(
              title: Text(status.labelVi),
              value: status,
              groupValue: order.status,
              onChanged: (value) async {
                if (value != null) {
                  try {
                    await Provider.of<OrderProvider>(context, listen: false)
                        .updateOrderStatus(order.id, value);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã cập nhật trạng thái')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi: $e')),
                      );
                    }
                  }
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context, order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận hủy đơn'),
        content: Text('Bạn có chắc muốn hủy đơn hàng #${order.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Không'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await Provider.of<OrderProvider>(context, listen: false)
                    .cancelOrder(order.id);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã hủy đơn hàng')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hủy đơn'),
          ),
        ],
      ),
    );
  }

  void _navigateToOrderDetail(BuildContext context, int orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailScreen(orderId: orderId),
      ),
    );
  }

  void _navigateToCreateOrder(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateOrderScreen(),
      ),
    ).then((_) {
      // Refresh sau khi tạo xong
      Provider.of<OrderProvider>(context, listen: false).refresh();
    });
  }
}

