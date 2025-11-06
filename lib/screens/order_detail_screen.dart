import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../widgets/order_status_badge.dart';
import '../widgets/order_item_row.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Order? _order;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    setState(() => _isLoading = true);
    
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final order = await orderProvider.getOrderById(widget.orderId);
    
    if (mounted) {
      setState(() {
        _order = order;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết #${widget.orderId}'),
        actions: [
          if (_order != null && _order!.canUpdateStatus)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showUpdateStatusDialog(),
              tooltip: 'Cập nhật trạng thái',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _order == null
              ? _buildError()
              : _buildContent(),
      bottomNavigationBar: _order != null && _order!.canCancel
          ? _buildBottomBar()
          : null,
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Không tìm thấy đơn hàng'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Quay lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Timeline
          _buildStatusTimeline(),
          
          const SizedBox(height: 24),

          // Thông tin chung
          _buildSection(
            'Thông tin chung',
            Icons.info_outline,
            [
              _buildInfoRow('ID đơn hàng', '#${_order!.id}'),
              _buildInfoRow('Loại', '${_order!.orderType.icon} ${_order!.orderType.labelVi}'),
              _buildInfoRow('Trạng thái', '', widget: OrderStatusBadge(status: _order!.status)),
              _buildInfoRow('Ngày tạo', _formatDateTime(_order!.orderDate)),
              if (_order!.staffId != null)
                _buildInfoRow('Người tạo', _order!.staffId!),
            ],
          ),

          const SizedBox(height: 16),

          // Thông tin đối tác
          _buildSection(
            _order!.isImport ? 'Nhà cung cấp' : 'Khách hàng',
            _order!.isImport ? Icons.business : Icons.person,
            [
              _buildInfoRow('Tên', _order!.partnerName ?? 'Không rõ'),
              if (_order!.partnerPhone != null)
                _buildInfoRow('Số điện thoại', _order!.partnerPhone!),
              if (_order!.partnerAddress != null)
                _buildInfoRow('Địa chỉ', _order!.partnerAddress!),
            ],
          ),

          const SizedBox(height: 16),

          // Danh sách sản phẩm
          _buildSection(
            'Sản phẩm (${_order!.items?.length ?? 0})',
            Icons.inventory_2,
            _order!.items?.map((item) => OrderItemRow(item: item)).toList() ?? [],
          ),

          const SizedBox(height: 16),

          // Tổng cộng
          Card(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng số lượng:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${_order!.totalQuantity} sản phẩm',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng tiền:',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${_formatPrice(_order!.totalAmount)} đ',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (_order!.notes != null && _order!.notes!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSection(
              'Ghi chú',
              Icons.note,
              [
                Text(
                  _order!.notes!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],

          const SizedBox(height: 80), // Space for bottom bar
        ],
      ),
    );
  }

  Widget _buildStatusTimeline() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildTimelineStep(OrderStatus.pending, 0),
            Expanded(child: _buildTimelineLine(0)),
            _buildTimelineStep(OrderStatus.processing, 1),
            Expanded(child: _buildTimelineLine(1)),
            _buildTimelineStep(OrderStatus.completed, 2),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep(OrderStatus status, int index) {
    final currentIndex = _getStatusIndex(_order!.status);
    final isActive = index <= currentIndex;
    final isCancelled = _order!.status == OrderStatus.cancelled;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCancelled && index > currentIndex
                ? Colors.grey[300]
                : isActive
                    ? _getStatusColor(status)
                    : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getStatusIcon(status),
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            status.labelVi,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.black87 : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineLine(int index) {
    final currentIndex = _getStatusIndex(_order!.status);
    final isActive = index < currentIndex;

    return Container(
      height: 2,
      color: isActive ? Theme.of(context).primaryColor : Colors.grey[300],
    );
  }

  int _getStatusIndex(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.processing:
        return 1;
      case OrderStatus.completed:
        return 2;
      case OrderStatus.cancelled:
        return 0;
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.amber;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.schedule;
      case OrderStatus.processing:
        return Icons.autorenew;
      case OrderStatus.completed:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Widget? widget}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ),
          Expanded(
            child: widget ??
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_order!.canUpdateStatus)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _showUpdateStatusDialog,
                icon: const Icon(Icons.edit),
                label: const Text('Cập nhật trạng thái'),
              ),
            ),
          if (_order!.canUpdateStatus && _order!.canCancel)
            const SizedBox(width: 12),
          if (_order!.canCancel)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _showCancelConfirmation,
                icon: const Icon(Icons.cancel),
                label: const Text('Hủy đơn'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showUpdateStatusDialog() {
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
              groupValue: _order!.status,
              onChanged: (value) async {
                if (value != null) {
                  try {
                    await Provider.of<OrderProvider>(context, listen: false)
                        .updateOrderStatus(_order!.id, value);
                    if (mounted) {
                      Navigator.pop(context);
                      await _loadOrder();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đã cập nhật trạng thái')),
                        );
                      }
                    }
                  } catch (e) {
                    if (mounted) {
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

  void _showCancelConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận hủy đơn'),
        content: Text('Bạn có chắc muốn hủy đơn hàng #${_order!.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Không'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await Provider.of<OrderProvider>(context, listen: false)
                    .cancelOrder(_order!.id);
                if (mounted) {
                  Navigator.pop(context); // Close dialog
                  await _loadOrder(); // Reload
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã hủy đơn hàng')),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
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

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}

