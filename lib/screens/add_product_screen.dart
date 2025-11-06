import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../providers/inventory_provider.dart';
import '../models/product.dart';
import '../utils/app_localizations.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product; // null for add, Product for edit

  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _initializeForEdit();
    }
  }

  void _initializeForEdit() {
    final product = widget.product!;
    _nameController.text = product.name;
    _codeController.text = product.code;
    _priceController.text = product.price.toString();
    _quantityController.text = product.quantity.toString();
    _minimumQuantityController.text = product.minimumQuantity.toString();
    _descriptionController.text = product.description;
    
    // Map category_id từ product
    _selectedCategoryId = product.categoryId;
    
    // Map brand_id từ product
    _selectedBrandId = product.brandId;
  }

  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _minimumQuantityController = TextEditingController();
  final _descriptionController = TextEditingController();

  int? _selectedCategoryId;
  int? _selectedBrandId;
  bool _isLoading = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _minimumQuantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error taking photo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery / Chọn từ thư viện'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo / Chụp ảnh'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            if (_selectedImage != null)
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Remove Image / Xóa ảnh'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedImage = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final now = DateTime.now();
      final inventoryProvider =
          Provider.of<InventoryProvider>(context, listen: false);
      
      // Lấy tên category và brand từ ID
      final selectedCategory = inventoryProvider.categoriesList
          .firstWhere((c) => c.id == _selectedCategoryId);
      final selectedBrand = inventoryProvider.brandsList
          .firstWhere((b) => b.id == _selectedBrandId);
      
      final product = Product(
        id: widget.product?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        code: _codeController.text.trim(),
        category: selectedCategory.name,
        categoryId: _selectedCategoryId,
        supplier: selectedBrand.name,
        brandId: _selectedBrandId,
        quantity: int.parse(_quantityController.text),
        price: double.parse(_priceController.text),
        description: _descriptionController.text.trim(),
        imageUrl: _selectedImage?.path ??
            widget.product?.imageUrl, // Store local file path for now
        minimumQuantity: int.parse(_minimumQuantityController.text),
        dateAdded: widget.product?.dateAdded ?? now,
        lastUpdated: now,
      );

      if (widget.product == null) {
        await inventoryProvider.addProduct(product);
      } else {
        await inventoryProvider.updateProduct(product);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.product == null
                ? 'Product added successfully / Sản phẩm đã được thêm thành công'
                : 'Product updated successfully / Sản phẩm đã được cập nhật thành công'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding product: $e'),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null
            ? l10n.addProduct
            : 'Edit Product / Chỉnh sửa sản phẩm'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProduct,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    l10n.save,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Image / Hình ảnh sản phẩm',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _showImagePicker,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate,
                                      size: 48,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Tap to add image / Nhấn để thêm ảnh',
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3, end: 0),

              const SizedBox(height: 16),

              // Basic Information
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Basic Information / Thông tin cơ bản',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 16),

                      // Product Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: '${l10n.productName} *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.inventory_2),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter product name / Vui lòng nhập tên sản phẩm';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Product Code
                      TextFormField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          labelText: '${l10n.productCode} *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.qr_code),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter product code / Vui lòng nhập mã sản phẩm';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Category - Dynamic từ Supabase
                      Consumer<InventoryProvider>(
                        builder: (context, inventoryProvider, child) {
                          final categories = inventoryProvider.categoriesList;
                          
                          // Set default nếu chưa có
                          if (_selectedCategoryId == null && categories.isNotEmpty) {
                            _selectedCategoryId = categories.first.id;
                          }
                          
                          return DropdownButtonFormField<int>(
                            value: _selectedCategoryId,
                            decoration: InputDecoration(
                              labelText: '${l10n.category} *',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.category),
                            ),
                            items: categories.map((category) {
                              return DropdownMenuItem<int>(
                                value: category.id,
                                child: Text(category.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategoryId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select category / Vui lòng chọn danh mục';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
                  .animate(delay: 100.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: -0.3, end: 0),

              const SizedBox(height: 16),

              // Pricing & Inventory
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pricing & Inventory / Giá cả & Kho hàng',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceController,
                              decoration: InputDecoration(
                                labelText: '${l10n.price} *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: const Icon(Icons.attach_money),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
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
                              decoration: InputDecoration(
                                labelText: '${l10n.quantity} *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: const Icon(Icons.inventory),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
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
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _minimumQuantityController,
                        decoration: InputDecoration(
                          labelText: 'Minimum Quantity / Số lượng tối thiểu *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.warning),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required / Bắt buộc';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Invalid quantity / Số lượng không hợp lệ';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              )
                  .animate(delay: 200.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: -0.3, end: 0),

              const SizedBox(height: 16),

              // Additional Information
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Additional Information / Thông tin bổ sung',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Brand/Supplier - Dynamic từ Supabase
                      Consumer<InventoryProvider>(
                        builder: (context, inventoryProvider, child) {
                          final brands = inventoryProvider.brandsList;
                          
                          // Set default nếu chưa có
                          if (_selectedBrandId == null && brands.isNotEmpty) {
                            _selectedBrandId = brands.first.id;
                          }
                          
                          return DropdownButtonFormField<int>(
                            value: _selectedBrandId,
                            decoration: InputDecoration(
                              labelText: '${l10n.supplier} / Brand *',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.business),
                            ),
                            items: brands.map((brand) {
                              return DropdownMenuItem<int>(
                                value: brand.id,
                                child: Text(brand.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedBrandId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select brand / Vui lòng chọn thương hiệu';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: '${l10n.description}',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.description),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              )
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: -0.3, end: 0),

              const SizedBox(height: 32),

              // Save Button
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProduct,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        l10n.save,
                        style: const TextStyle(fontSize: 16),
                      ),
              ).animate(delay: 400.ms).fadeIn(duration: 600.ms).scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
