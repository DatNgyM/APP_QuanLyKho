import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:io';

import '../models/product.dart';
import '../providers/inventory_provider.dart';
import '../utils/app_localizations.dart';
import '../screens/add_product_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEdit(context),
            tooltip: 'Edit Product',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () =>
                _showDeleteDialog(context, l10n, inventoryProvider),
            tooltip: 'Delete Product',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            _buildProductImage(context)
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(
                    begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0)),

            const SizedBox(height: 24),

            // Product Information Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product.name,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ).animate().fadeIn(duration: 600.ms, delay: 200.ms),

                    const SizedBox(height: 8),

                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        product.category,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 400.ms),

                    const SizedBox(height: 24),

                    // Product Details Grid
                    _buildDetailsGrid(context)
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 600.ms),

                    const SizedBox(height: 24),

                    // Description
                    if (product.description.isNotEmpty)
                      ...[
                Text(
                  'Description / Mô tả',
                  style:
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                  overflow: TextOverflow.ellipsis,
                ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceVariant
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            product.description,
                            style: Theme.of(context).textTheme.bodyLarge,
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ].animate().fadeIn(duration: 600.ms, delay: 800.ms),

                    const SizedBox(height: 24),

                    // Date Information
                    _buildDateInfo(context)
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 1000.ms),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: _getProductImage(context),
        ),
      ),
    );
  }

  Widget _getProductImage(BuildContext context) {
    if (product.imageUrl == null || product.imageUrl!.isEmpty) {
      return Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Icon(
          Icons.inventory_2,
          size: 80,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    if (product.imageUrl!.startsWith('http')) {
      return Image.network(
        product.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Icon(
            Icons.broken_image,
            size: 80,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    } else {
      return Image.file(
        File(product.imageUrl!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Icon(
            Icons.broken_image,
            size: 80,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }
  }

  Widget _buildDetailsGrid(BuildContext context) {
    return Column(
      children: [
        // Row 1: Price and Quantity
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(
                context,
                'Price / Giá',
                '\$${product.price.toStringAsFixed(2)}',
                Icons.attach_money,
                Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDetailCard(
                context,
                'Quantity / Số lượng',
                '${product.quantity}',
                Icons.inventory,
                product.quantity <= product.minimumQuantity
                    ? Theme.of(context).colorScheme.error
                    : Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Row 2: Code and Supplier
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(
                context,
                'Product Code / Mã SP',
                product.code,
                Icons.qr_code,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDetailCard(
                context,
                'Supplier / Nhà CC',
                product.supplier,
                Icons.business,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Row 3: Minimum Quantity (full width)
        _buildDetailCard(
          context,
          'Minimum Quantity / SL tối thiểu',
          '${product.minimumQuantity}',
          Icons.warning,
          product.quantity <= product.minimumQuantity
              ? Theme.of(context).colorScheme.error
              : Colors.grey,
        ),
      ],
    );
  }

  Widget _buildDetailCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            color:
                Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date Added / Ngày thêm:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.7),
                      ),
                ),
                Text(
                  _formatDate(product.dateAdded),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Last Updated / Cập nhật:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.7),
                      ),
                ),
                Text(
                  _formatDate(product.lastUpdated),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today / Hôm nay';
    } else if (difference.inDays == 1) {
      return 'Yesterday / Hôm qua';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago / ${difference.inDays} ngày trước';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _navigateToEdit(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddProductScreen(product: product),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    AppLocalizations l10n,
    InventoryProvider inventoryProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            Text(l10n.deleteProduct),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.areYouSure}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Product: ${product.name}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.deleteConfirmation,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              inventoryProvider.deleteProduct(product.id);
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to inventory
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.productDeleted),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
