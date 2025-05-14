import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/routes/app_router.dart';
import '../../../domain/entities/event.dart';
import '../../blocs/event_bloc/event_bloc.dart';
import '../../blocs/event_bloc/event_event.dart';
import '../../blocs/event_bloc/event_state.dart';
import '../../widgets/event_card.dart';
import '../../widgets/event_card_shimmer.dart';

class SearchEventsScreen extends StatefulWidget {
  const SearchEventsScreen({super.key});

  @override
  State<SearchEventsScreen> createState() => _SearchEventsScreenState();
}

class _SearchEventsScreenState extends State<SearchEventsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = '';
  double _minPrice = 0;
  double _maxPrice = 1000;
  DateTime? _startDate;
  bool _showFilters = false;

  // Predefined categories
  final List<String> _categories = [
    'All',
    'Music',
    'Technology',
    'Business',
    'Food',
    'Sports',
    'Art',
    'Education',
    'Health',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = _categories[0]; // Default to 'All'
    // Trigger event loading
    context.read<EventBloc>().add(const LoadEvents());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Event> _filterEvents(List<Event> events) {
    return events.where((event) {
      // Filter by search query
      final matchesQuery = _searchQuery.isEmpty ||
          event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          event.location.toLowerCase().contains(_searchQuery.toLowerCase());

      // Filter by category
      final matchesCategory =
          _selectedCategory == 'All' || event.category == _selectedCategory;

      // Filter by price
      final matchesPrice = event.price >= _minPrice && event.price <= _maxPrice;

      // Filter by date
      final matchesDate = _startDate == null ||
          event.startDate.isAfter(_startDate!) ||
          event.startDate.isAtSameMomentAs(_startDate!);

      return matchesQuery && matchesCategory && matchesPrice && matchesDate;
    }).toList();
  }

  void _applySearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedCategory = _categories[0];
      _minPrice = 0;
      _maxPrice = 1000;
      _startDate = null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search events...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _applySearch('');
              },
            ),
          ),
          onSubmitted: _applySearch,
          textInputAction: TextInputAction.search,
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
            ),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters section
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showFilters ? null : 0,
            child: Visibility(
              visible: _showFilters,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Category filter
                    const Text('Category'),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = category == _selectedCategory;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedCategory = category;
                                  });
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Price range filter
                    Row(
                      children: [
                        const Text('Price Range'),
                        const Spacer(),
                        Text(
                          '\$${_minPrice.toStringAsFixed(0)} - \$${_maxPrice.toStringAsFixed(0)}',
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: RangeValues(_minPrice, _maxPrice),
                      min: 0,
                      max: 1000,
                      divisions: 20,
                      labels: RangeLabels(
                        '\$${_minPrice.toStringAsFixed(0)}',
                        '\$${_maxPrice.toStringAsFixed(0)}',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _minPrice = values.start;
                          _maxPrice = values.end;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Date filter
                    Row(
                      children: [
                        const Text('From Date'),
                        const Spacer(),
                        TextButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: Text(
                            _startDate == null
                                ? 'Select'
                                : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                          ),
                          onPressed: () => _selectDate(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Reset button
                    Center(
                      child: OutlinedButton(
                        onPressed: _resetFilters,
                        child: const Text('Reset Filters'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Divider
          if (_showFilters) const Divider(height: 1),

          // Events list
          Expanded(
            child: BlocBuilder<EventBloc, EventState>(
              builder: (context, state) {
                if (state is EventLoading) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 3,
                    itemBuilder: (context, index) => const EventCardShimmer(),
                  );
                }

                if (state is EventError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Something went wrong',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(state.message),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            context.read<EventBloc>().add(const LoadEvents());
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is EventLoaded) {
                  final filteredEvents = _filterEvents(state.events);

                  if (filteredEvents.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off,
                              size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            'No events found',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your filters',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      return EventCard(
                        event: event,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRouter.eventDetails,
                            arguments: event.id,
                          );
                        },
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
