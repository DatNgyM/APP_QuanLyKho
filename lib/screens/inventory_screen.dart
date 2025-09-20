import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/inventory_provider.dart';
import '../providers/language_provider.dart';
import '../models/product.dart';
import '../utils/app_localizations.dart';
import '../widgets/product_card.dart';
import '../widgets/search_filter_bar.dart';
import 'add_product_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inventory),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => languageProvider.toggleLanguage(),
            tooltip: languageProvider.currentLanguageName,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          SearchFilterBar(
            searchQuery: inventoryProvider.searchQuery,
            selectedCategory: inventoryProvider.selectedCategory,
            sortBy: inventoryProvider.sortBy,
            sortAscending: inventoryProvider.sortAscending,
            categories: inventoryProvider.categories,
            sortOptions: inventoryProvider.sortOptions,
            onSearchChanged: inventoryProvider.setSearchQuery,
            onCategoryChanged: inventoryProvider.setSelectedCategory,
            onSortChanged: inventoryProvider.setSortBy,
            onSortDirectionChanged: inventoryProvider.setSortAscending,
          ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3, end: 0),

          // Products List
          Expanded(
            child: inventoryProvider.products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 80,
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noData,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No products found / Không tìm thấy sản phẩm',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color?.withOpacity(0.5),
                              ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: inventoryProvider.products.length,
                    itemBuilder: (context, index) {
                      final product = inventoryProvider.products[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          // TODO: Navigate to product details
                        },
                        onEdit: () {
                          // TODO: Navigate to edit product
                        },
                        onDelete: () {
                          _showDeleteDialog(context, product, l10n);
                        },
                      )
                          .animate(delay: Duration(milliseconds: 100 * index))
                          .fadeIn(duration: 600.ms)
                          .slideX(begin: -0.3, end: 0);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddProductScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      )
          .animate()
          .scale(duration: 800.ms, curve: Curves.elasticOut)
          .fadeIn(duration: 600.ms),
    );
  }

  void _showDeleteDialog(BuildContext context, product, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteProduct),
        content: Text('${l10n.areYouSure}\n${l10n.deleteConfirmation}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<InventoryProvider>(
                context,
                listen: false,
              ).deleteProduct(product.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.productDeleted),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
