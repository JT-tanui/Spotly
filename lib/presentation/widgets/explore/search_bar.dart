import 'package:flutter/material.dart';
import 'dart:ui';

class CustomSearchDelegate extends SearchDelegate<String> {
  final List<String> _recentSearches = [
    'Live music',
    'Jazz night',
    'Weekend events',
    'Art exhibition',
    'Food festival',
  ];

  final List<String> _suggestions = [
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

  @override
  ThemeData appBarTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);

    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Theme.of(context).hintColor,
          fontFamily: 'Inter',
        ),
      ),
      textTheme: Theme.of(context).textTheme.copyWith(
            titleLarge: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontFamily: 'Inter',
              fontSize: 16,
            ),
          ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primaryColor,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return _buildSuggestionsUI(context);
    }

    // Save to recent searches
    if (!_recentSearches.contains(query) && query.isNotEmpty) {
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 5) {
        _recentSearches.removeLast();
      }
    }

    return _buildResultsUI(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSuggestionsUI(context);
  }

  Widget _buildSuggestionsUI(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: CustomScrollView(
        slivers: [
          // Recent searches
          if (_recentSearches.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Searches',
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    if (_recentSearches.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          _recentSearches.clear();
                          // Force rebuild
                          showSuggestions(context);
                        },
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            color: primaryColor,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final search = _recentSearches[index];
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(
                      search,
                      style: const TextStyle(fontFamily: 'Inter'),
                    ),
                    onTap: () {
                      query = search;
                      showResults(context);
                    },
                  );
                },
                childCount: _recentSearches.length,
              ),
            ),
          ],

          // Suggested searches
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Suggested Searches',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
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
                children: _suggestions.map((suggestion) {
                  return InkWell(
                    onTap: () {
                      query = suggestion;
                      showResults(context);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        suggestion,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsUI(BuildContext context) {
    // This would be replaced with actual API results
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Search results for "$query"',
            style: const TextStyle(
              fontFamily: 'Sora',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This would display actual results from the API',
            style: TextStyle(
              fontFamily: 'Inter',
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
