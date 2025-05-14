import 'package:flutter/material.dart';
import '../../domain/entities/event_category.dart';

class CategorySelector extends StatefulWidget {
  final List<EventCategory>? initialValue;
  final Function(List<EventCategory>) onCategoriesSelected;

  const CategorySelector({
    Key? key,
    this.initialValue,
    required this.onCategoriesSelected,
  }) : super(key: key);

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late List<EventCategory> _selectedCategories;

  @override
  void initState() {
    super.initState();
    _selectedCategories =
        widget.initialValue ?? [EventCategory.predefinedCategories.first];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected categories display
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _selectedCategories.map((category) {
            return Chip(
              label: Text(category.name),
              backgroundColor: category.colorValue.withOpacity(0.1),
              side: BorderSide(
                color: category.colorValue.withOpacity(0.3),
              ),
              avatar: Icon(
                category.iconData,
                color: category.colorValue,
                size: 16,
              ),
              labelStyle: TextStyle(
                color: category.colorValue,
                fontSize: 12,
              ),
              deleteIcon: Icon(
                Icons.close,
                size: 16,
                color: category.colorValue,
              ),
              onDeleted: () {
                setState(() {
                  _selectedCategories.remove(category);
                });
                widget.onCategoriesSelected(_selectedCategories);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        // Category selection grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: EventCategory.predefinedCategories.length,
          itemBuilder: (context, index) {
            final category = EventCategory.predefinedCategories[index];
            final isSelected = _selectedCategories.contains(category);
            return InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedCategories.remove(category);
                  } else {
                    _selectedCategories.add(category);
                  }
                });
                widget.onCategoriesSelected(_selectedCategories);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? category.colorValue.withOpacity(0.2)
                      : Colors.transparent,
                  border: Border.all(
                    color:
                        isSelected ? category.colorValue : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category.iconData,
                      color: isSelected ? category.colorValue : Colors.grey,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.name,
                      style: TextStyle(
                        color: isSelected ? category.colorValue : Colors.grey,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
