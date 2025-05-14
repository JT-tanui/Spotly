import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotly/config/routes/app_router.dart';
import 'package:spotly/presentation/blocs/explore_bloc/explore_bloc.dart';
import 'package:spotly/presentation/blocs/explore_bloc/explore_state.dart';
import 'package:spotly/presentation/blocs/location_bloc/location_bloc.dart';
import 'package:spotly/presentation/blocs/location_bloc/location_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final List<String> _recentSearches = [
    'Live music',
    'Jazz night',
    'Weekend events',
    'Art exhibition',
    'Food festival',
  ];

  final List<String> _trendingSearches = [
    'Rooftop bar',
    'Outdoor dining',
    'Pride events',
    'Farmers market',
    'Street food',
  ];

  final List<String> _categories = [
    'Popular',
    'Today',
    'Weekend',
    'Free',
    'Music',
    'Food',
    'Workshops',
    'Family friendly',
    'Nightlife',
  ];

  String _searchQuery = '';
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Color system
    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;
    final surfaceColor =
        isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF9F9F9);
    final primaryAccent =
        isDark ? const Color(0xFFFF7F7F) : const Color(0xFFFF6B6B); // Coral Red
    final secondaryAccent =
        isDark ? const Color(0xFF8A80FF) : const Color(0xFF6C63FF); // Indigo
    final textPrimary =
        isDark ? const Color(0xFFF1F1F1) : const Color(0xFF212121);
    final textSecondary =
        isDark ? const Color(0xFFB5B5B5) : const Color(0xFF6B6B6B);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Search places, events, or restaurants near you',
                    hintStyle: TextStyle(color: textSecondary, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _showResults = value.isNotEmpty;
                    });
                  },
                  onSubmitted: (value) {
                    if (value.isNotEmpty && !_recentSearches.contains(value)) {
                      setState(() {
                        _recentSearches.insert(0, value);
                        if (_recentSearches.length > 10) {
                          _recentSearches.removeLast();
                        }
                      });
                    }
                    setState(() {
                      _showResults = value.isNotEmpty;
                    });
                  },
                ),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: Icon(Icons.close, color: textPrimary),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _searchQuery = '';
                    _showResults = false;
                  });
                },
              ),
          ],
        ),
      ),
      body: _showResults
          ? _buildSearchResults(context, primaryAccent, secondaryAccent,
              textPrimary, textSecondary)
          : _buildSearchSuggestions(
              context, surfaceColor, primaryAccent, textPrimary, textSecondary),
    );
  }

  Widget _buildSearchSuggestions(BuildContext context, Color surfaceColor,
      Color primaryAccent, Color textPrimary, Color textSecondary) {
    return CustomScrollView(
      slivers: [
        // Location context
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                String locationText = 'Anywhere';

                if (state is LocationLoaded) {
                  locationText = state.address ?? 'Current Location';
                }

                return Row(
                  children: [
                    Text(
                      'Searching near:',
                      style: TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: primaryAccent.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: primaryAccent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            locationText,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        // Recent searches
        if (_recentSearches.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Searches',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _recentSearches.clear();
                      });
                      HapticFeedback.mediumImpact();
                    },
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 14,
                        color: primaryAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (_recentSearches.isNotEmpty)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  leading: Icon(
                    Icons.history,
                    size: 18,
                    color: textSecondary,
                  ),
                  title: Text(
                    _recentSearches[index],
                    style: TextStyle(
                      fontSize: 15,
                      color: textPrimary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.north_west,
                    size: 16,
                    color: textSecondary,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  visualDensity: VisualDensity.compact,
                  onTap: () {
                    setState(() {
                      _searchController.text = _recentSearches[index];
                      _searchQuery = _recentSearches[index];
                      _showResults = true;
                    });
                    HapticFeedback.selectionClick();
                  },
                );
              },
              childCount: _recentSearches.length,
            ),
          ),

        // Trending searches
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Text(
              'Trending Now',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _trendingSearches.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://source.unsplash.com/random/200x200/?${_trendingSearches[index].replaceAll(' ', '')}',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _trendingSearches[index],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: textPrimary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        // Categories
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _searchController.text = category;
                      _searchQuery = category;
                      _showResults = true;
                    });
                    HapticFeedback.selectionClick();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: primaryAccent.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 13,
                        color: textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context, Color primaryAccent,
      Color secondaryAccent, Color textPrimary, Color textSecondary) {
    // This would connect to the real data source in a production app
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        if (state is ExploreLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ExploreLoaded) {
          // Simulate filtering results based on query
          // In a real app, you would dispatch a search event to the bloc
          final results = state.recommendedEvents
              .where((event) => event.title
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
              .toList();

          if (results.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No results found for "$_searchQuery"',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try a different search term or browse categories',
                    style: TextStyle(
                      fontSize: 14,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Results for "$_searchQuery"',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      Text(
                        '${results.length} found',
                        style: TextStyle(
                          fontSize: 14,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final event = results[index];
                    return InkWell(
                      onTap: () {
                        // Navigate to event details
                        Navigator.pushNamed(
                          context,
                          AppRouter.eventDetails,
                          arguments: event.id,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image section
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    event.imageUrl,
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // Gradient overlay for better text visibility
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Category and Date badges
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: primaryAccent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      event.categories.isNotEmpty
                                          ? event.categories.first
                                          : 'Event',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _formatDate(event.startDate),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Details section
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 14,
                                        color: textSecondary,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          event.location,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: textSecondary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: textSecondary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatTime(event.startDate),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: textSecondary,
                                        ),
                                      ),
                                      Text(
                                        ' - ',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: textSecondary,
                                        ),
                                      ),
                                      Text(
                                        _formatTime(event.endDate),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: results.length,
                ),
              ),
            ],
          );
        }

        return const Center(child: Text('No data available'));
      },
    );
  }

  // Helper to format date
  String _formatDate(DateTime date) {
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${monthNames[date.month - 1]} ${date.day}';
  }

  // Helper to format time
  String _formatTime(DateTime time) {
    final hour =
        time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
