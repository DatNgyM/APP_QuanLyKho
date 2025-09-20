import 'package:flutter/material.dart';

class SearchFilterBar extends StatelessWidget {
  final String searchQuery;
  final String selectedCategory;
  final String sortBy;
  final bool sortAscending;
  final List<String> categories;
  final List<String> sortOptions;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<bool> onSortDirectionChanged;

  const SearchFilterBar({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    required this.sortBy,
    required this.sortAscending,
    required this.categories,
    required this.sortOptions,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onSortChanged,
    required this.onSortDirectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search products / Tìm kiếm sản phẩm',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => onSearchChanged(''),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              isDense: true,
            ),
          ),

          const SizedBox(height: 12),

          // Filter Row
          Row(
            children: [
              // Category Filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.background,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    isDense: true,
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(
                        category,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onCategoryChanged(value);
                    }
                  },
                ),
              ),

              const SizedBox(width: 16),

              // Sort Filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: sortBy,
                  decoration: InputDecoration(
                    labelText: 'Sort by',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.background,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    isDense: true,
                  ),
                  items: sortOptions.map((option) {
                    String displayText;
                    switch (option) {
                      case 'name':
                        displayText = 'Name';
                        break;
                      case 'price':
                        displayText = 'Price';
                        break;
                      case 'quantity':
                        displayText = 'Quantity';
                        break;
                      case 'dateAdded':
                        displayText = 'Date Added';
                        break;
                      case 'lastUpdated':
                        displayText = 'Last Updated';
                        break;
                      default:
                        displayText = option;
                    }
                    return DropdownMenuItem(
                      value: option,
                      child: Text(
                        displayText,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onSortChanged(value);
                    }
                  },
                ),
              ),

              const SizedBox(width: 8),

              // Sort Direction Toggle
              IconButton(
                onPressed: () => onSortDirectionChanged(!sortAscending),
                icon: Icon(
                  sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 20,
                ),
                tooltip: sortAscending ? 'Ascending' : 'Descending',
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                  minimumSize: const Size(40, 40),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
