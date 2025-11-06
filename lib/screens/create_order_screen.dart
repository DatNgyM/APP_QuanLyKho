import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';
import '../providers/inventory_provider.dart';
import '../models/order_type.dart';
import '../models/order_item.dart';
import '../models/product.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  OrderType _selectedType = OrderType.import;
  
  // Partner info
  final _partnerNameController = TextEditingController();
  final _partnerPhoneController = TextEditingController();
  final _partnerAddressController = TextEditingController();
  final _notesController = TextEditingController();

  // Selected products
  final List<_SelectedProduct> _selectedProducts = [];

  bool _isSubmitting = false;

  @override
  void dispose() {
    _partnerNameController.dispose();
    _partnerPhoneController.dispose();
    _partnerAddressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo đơn hàng'),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submitForm,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Lưu',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Loại đơn
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loại đơn hàng',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<OrderType>(
                            title: Text('⬇️ ${OrderType.import.labelVi}'),
                            value: OrderType.import,
                            groupValue: _selectedType,
                            onChanged: (value) {
                              setState(() => _selectedType = value!);
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<OrderType>(
                            title: Text('⬆️ ${OrderType.export.labelVi}'),
                            value: OrderType.export,
                            groupValue: _selectedType,
                            onChanged: (value) {
                              setState(() => _selectedType = value!);
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Thông tin đối tác
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedType == OrderType.import
                          ? 'Thông tin nhà cung cấp'
                          : 'Thông tin khách hàng',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _partnerNameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _partnerPhoneController,
                      decoration: const InputDecoration(
                        labelText: 'Số điện thoại',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _partnerAddressController,
                      decoration: const InputDecoration(
                        labelText: 'Địa chỉ',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Danh sách sản phẩm
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sản phẩm (${_selectedProducts.length})',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _showProductSelector,
                          icon: const Icon(Icons.add, size: 20),
                          label: const Text('Thêm'),
                        ),
                      ],
                    ),
                    if (_selectedProducts.isEmpty) ...[
                      const SizedBox(height: 24),
                      Center(
                        child: Column(
                          children: [
                            Icon(Icons.inventory_2, size: 48, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text(
                              'Chưa có sản phẩm nào',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ] else ...[
                      const Divider(height: 24),
                      ..._selectedProducts.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return _buildProductItem(item, index);
                      }),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Ghi chú
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ghi chú',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        hintText: 'Nhập ghi chú (tùy chọn)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tổng cộng
            if (_selectedProducts.isNotEmpty)
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
                            '${_getTotalQuantity()} sản phẩm',
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
                            '${_formatPrice(_getTotalAmount())} đ',
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

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(_SelectedProduct item, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatPrice(item.product.price)} đ',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 80,
              child: TextField(
                controller: item.quantityController,
                decoration: const InputDecoration(
                  labelText: 'SL',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  item.quantityController.dispose();
                  _selectedProducts.removeAt(index);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showProductSelector() {
    final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
    final products = inventoryProvider.products;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Chọn sản phẩm',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final isSelected = _selectedProducts.any((p) => p.product.id == product.id);

                  return ListTile(
                    leading: Icon(
                      Icons.inventory_2,
                      color: isSelected ? Theme.of(context).primaryColor : null,
                    ),
                    title: Text(product.name),
                    subtitle: Text('${_formatPrice(product.price)} đ • Còn ${product.quantity}'),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    onTap: () {
                      if (!isSelected) {
                        setState(() {
                          _selectedProducts.add(_SelectedProduct(product));
                        });
                        Navigator.pop(context);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getTotalQuantity() {
    return _selectedProducts.fold(0, (sum, item) => sum + (int.tryParse(item.quantityController.text) ?? 0));
  }

  double _getTotalAmount() {
    return _selectedProducts.fold(0.0, (sum, item) {
      final qty = int.tryParse(item.quantityController.text) ?? 0;
      return sum + (qty * item.product.price);
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng thêm ít nhất 1 sản phẩm')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);

      // Convert to OrderItems
      final items = _selectedProducts.map((item) {
        final qty = int.tryParse(item.quantityController.text) ?? 0;
        return OrderItem(
          id: 0, // Will be set by DB
          orderId: 0, // Will be set by DB
          productId: int.parse(item.product.id),
          quantity: qty,
          unitPrice: item.product.price,
        );
      }).toList();

      await orderProvider.createOrder(
        orderType: _selectedType,
        items: items,
        partnerName: _partnerNameController.text,
        partnerPhone: _partnerPhoneController.text.isNotEmpty ? _partnerPhoneController.text : null,
        partnerAddress: _partnerAddressController.text.isNotEmpty ? _partnerAddressController.text : null,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Đã tạo đơn hàng thành công')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Lỗi: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}

class _SelectedProduct {
  final Product product;
  final TextEditingController quantityController;

  _SelectedProduct(this.product)
      : quantityController = TextEditingController(text: '1');
}

