import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/inventory_provider.dart';
import '../utils/app_localizations.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _minimumQuantityController = TextEditingController();
  final _supplierController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Electronics';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _minimumQuantityController.dispose();
    _supplierController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final now = DateTime.now();
    final product = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      code: _codeController.text.trim(),
      category: _selectedCategory,
      quantity: int.parse(_quantityController.text),
      price: double.parse(_priceController.text),
      description: _descriptionController.text.trim(),
      supplier: _supplierController.text.trim(),
      minimumQuantity: int.parse(_minimumQuantityController.text),
      dateAdded: now,
      lastUpdated: now,
    );

    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    if (mounted) {
      Provider.of<InventoryProvider>(
        context,
        listen: false,
      ).addProduct(product);

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).productAdded),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addProduct),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProduct,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(l10n.save, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Image Section
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 60,
                      color: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.selectImage,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 600.ms).scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1, 1),
                  ),

              const SizedBox(height: 24),

              // Product Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.productName,
                  prefixIcon: const Icon(Icons.inventory_2),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name / Vui lòng nhập tên sản phẩm';
                  }
                  return null;
                },
              )
                  .animate(delay: 100.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),

              const SizedBox(height: 16),

              // Product Code
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: l10n.productCode,
                  prefixIcon: const Icon(Icons.qr_code),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product code / Vui lòng nhập mã sản phẩm';
                  }
                  return null;
                },
              )
                  .animate(delay: 200.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),

              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: l10n.category,
                  prefixIcon: const Icon(Icons.category),
                ),
                items: inventoryProvider.categories
                    .where((category) => category != 'All')
                    .map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              )
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),

              const SizedBox(height: 16),

              // Price and Quantity Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '${l10n.price} (\$)',
                        prefixIcon: const Icon(Icons.attach_money),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required / Bắt buộc';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid price / Giá không hợp lệ';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.quantity,
                        prefixIcon: const Icon(Icons.inventory),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required / Bắt buộc';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Invalid quantity / Số lượng không hợp lệ';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),

              const SizedBox(height: 16),

              // Minimum Quantity and Supplier Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _minimumQuantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Min ${l10n.quantity} / Số lượng tối thiểu',
                        prefixIcon: const Icon(Icons.warning),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required / Bắt buộc';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Invalid number / Số không hợp lệ';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _supplierController,
                      decoration: InputDecoration(
                        labelText: l10n.supplier,
                        prefixIcon: const Icon(Icons.business),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter supplier / Vui lòng nhập nhà cung cấp';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              )
                  .animate(delay: 500.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),

              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: l10n.description,
                  prefixIcon: const Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description / Vui lòng nhập mô tả';
                  }
                  return null;
                },
              )
                  .animate(delay: 600.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProduct,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          l10n.save,
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              )
                  .animate(delay: 700.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
