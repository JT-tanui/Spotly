import 'package:flutter/material.dart';

class FilterOption {
  final String name;
  final IconData icon;
  bool isSelected;

  FilterOption({
    required this.name,
    required this.icon,
    this.isSelected = false,
  });
}

class FilterCategory {
  final String title;
  final List<FilterOption> options;

  FilterCategory({
    required this.title,
    required this.options,
  });
}

class FilterSheet extends StatefulWidget {
  final Function(Map<String, List<String>>) onApply;

  const FilterSheet({
    super.key,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required Function(Map<String, List<String>>) onApply,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterSheet(onApply: onApply),
    );
  }

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  // Store selected filters
  final Map<String, List<String>> _selectedFilters = {};

  // Filter categories
  late List<FilterCategory> _filterCategories;

  // Date range selection
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _initializeFilters();
  }

  void _initializeFilters() {
    _filterCategories = [
      FilterCategory(
        title: 'Type',
        options: [
          FilterOption(name: 'Event', icon: Icons.event),
          FilterOption(name: 'Restaurant', icon: Icons.restaurant),
          FilterOption(name: 'Activity', icon: Icons.sports_soccer),
        ],
      ),
      FilterCategory(
        title: 'Vibe',
        options: [
          FilterOption(name: 'Chill', icon: Icons.nightlight_round),
          FilterOption(name: 'Luxury', icon: Icons.star),
          FilterOption(name: 'Party', icon: Icons.celebration),
          FilterOption(name: 'Outdoors', icon: Icons.landscape),
        ],
      ),
      FilterCategory(
        title: 'Price Range',
        options: [
          FilterOption(name: '\$', icon: Icons.attach_money),
          FilterOption(name: '\$\$', icon: Icons.attach_money),
          FilterOption(name: '\$\$\$', icon: Icons.attach_money),
        ],
      ),
      FilterCategory(
        title: 'Time',
        options: [
          FilterOption(name: 'Today', icon: Icons.today),
          FilterOption(name: 'This Week', icon: Icons.date_range),
          FilterOption(name: 'This Month', icon: Icons.calendar_month),
          FilterOption(name: 'Custom', icon: Icons.event_available),
        ],
      ),
    ];
  }

  void _toggleOption(String category, FilterOption option) {
    setState(() {
      option.isSelected = !option.isSelected;

      // Update selected filters map
      if (option.isSelected) {
        if (!_selectedFilters.containsKey(category)) {
          _selectedFilters[category] = [];
        }
        _selectedFilters[category]!.add(option.name);
      } else {
        _selectedFilters[category]?.remove(option.name);
        if (_selectedFilters[category]?.isEmpty ?? false) {
          _selectedFilters.remove(category);
        }
      }
    });
  }

  void _resetFilters() {
    setState(() {
      for (var category in _filterCategories) {
        for (var option in category.options) {
          option.isSelected = false;
        }
      }
      _selectedFilters.clear();
      _selectedDateRange = null;
    });
  }

  void _applyFilters() {
    widget.onApply(_selectedFilters);
    Navigator.pop(context);
  }

  Future<void> _selectDateRange() async {
    final initialDateRange = _selectedDateRange ??
        DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 7)),
        );

    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: initialDateRange,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor:
                  isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF),
              brightness: Theme.of(context).brightness,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newDateRange != null) {
      setState(() {
        _selectedDateRange = newDateRange;

        // Update selected filters for custom date range
        if (!_selectedFilters.containsKey('Time')) {
          _selectedFilters['Time'] = [];
        }

        // Remove other time options
        _selectedFilters['Time'] = ['Custom'];

        // Update UI
        for (var option in _filterCategories[3].options) {
          option.isSelected = option.name == 'Custom';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);
    final accentColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle and header
              Container(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white38 : Colors.black26,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Title and close button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            'Filters',
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ],
                      ),
                    ),

                    // Selected filters chips
                    if (_selectedFilters.isNotEmpty)
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ..._buildSelectedFiltersChips(),
                            // Reset button
                            ActionChip(
                              avatar: Icon(
                                Icons.restart_alt,
                                size: 18,
                                color: accentColor,
                              ),
                              label: Text(
                                'Reset All',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: accentColor,
                                ),
                              ),
                              backgroundColor: accentColor.withOpacity(0.1),
                              onPressed: _resetFilters,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Scrollable filter options
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Filter categories
                    ..._filterCategories
                        .map((category) => _buildFilterCategory(category)),

                    // Custom date range selection if enabled
                    if (_selectedDateRange != null &&
                        _filterCategories[3]
                            .options
                            .any((o) => o.name == 'Custom' && o.isSelected))
                      Card(
                        margin: const EdgeInsets.only(top: 16),
                        elevation: 0,
                        color: primaryColor.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: primaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date Range',
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      color: primaryColor, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month}/${_selectedDateRange!.start.year} - '
                                    '${_selectedDateRange!.end.day}/${_selectedDateRange!.end.month}/${_selectedDateRange!.end.year}',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: _selectDateRange,
                                    child: Text(
                                      'Change',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Apply button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? const Color(0xFF9B79FF)
                        : const Color(0xFF6F3DFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterCategory(FilterCategory category) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            category.title,
            style: TextStyle(
              fontFamily: 'Sora',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: category.options.map((option) {
            return _buildFilterOption(
              category.title,
              option,
              onTap: () {
                _toggleOption(category.title, option);

                // Special handling for Time category
                if (category.title == 'Time') {
                  if (option.name == 'Custom' && option.isSelected) {
                    _selectDateRange();
                  } else if (option.isSelected) {
                    // Deselect other time options
                    for (var o in category.options) {
                      if (o.name != option.name) {
                        o.isSelected = false;
                      }
                    }
                    // Update selected filters
                    _selectedFilters['Time'] = [option.name];
                    // Clear date range if Custom is not selected
                    if (option.name != 'Custom') {
                      _selectedDateRange = null;
                    }
                  }
                }
              },
            );
          }).toList(),
        ),
        const Divider(height: 32),
      ],
    );
  }

  Widget _buildFilterOption(String category, FilterOption option,
      {required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: option.isSelected
              ? primaryColor.withOpacity(0.2)
              : (isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: option.isSelected
                ? primaryColor
                : (isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              option.icon,
              size: 18,
              color: option.isSelected
                  ? primaryColor
                  : (isDark ? Colors.white70 : Colors.black54),
            ),
            const SizedBox(width: 8),
            Text(
              option.name,
              style: TextStyle(
                fontFamily: 'Inter',
                color: option.isSelected
                    ? primaryColor
                    : (isDark ? Colors.white : Colors.black87),
                fontWeight:
                    option.isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSelectedFiltersChips() {
    final chips = <Widget>[];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);

    _selectedFilters.forEach((category, options) {
      for (var option in options) {
        chips.add(
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(
              label: Text(
                '$category: $option',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 12,
                ),
              ),
              backgroundColor: primaryColor.withOpacity(0.1),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () {
                // Find and deselect the option
                for (var cat in _filterCategories) {
                  if (cat.title == category) {
                    for (var opt in cat.options) {
                      if (opt.name == option) {
                        _toggleOption(category, opt);
                        break;
                      }
                    }
                    break;
                  }
                }
              },
            ),
          ),
        );
      }
    });

    return chips;
  }
}
