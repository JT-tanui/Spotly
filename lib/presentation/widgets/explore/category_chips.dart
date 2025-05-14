import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CategoryChips extends StatelessWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryChips({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      'All',
      'Food',
      'Entertainment',
      'Sports',
      'Arts',
      'Music',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: categories.map((category) {
          final isSelected = category == selectedCategory ||
              (category == 'All' && selectedCategory == null);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onCategorySelected(category == 'All' ? '' : category);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
