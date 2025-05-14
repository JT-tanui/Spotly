import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search places and events...',
            border: InputBorder.none,
            suffixIcon: _isSearching
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _isSearching = false);
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() => _isSearching = value.isNotEmpty);
            // TODO: Implement search functionality
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter modal
            },
          ),
        ],
      ),
      body: _isSearching
          ? const Center(
              child: Text('Search Results Coming Soon'),
            )
          : Column(
              children: [
                // Recent Searches
                ListTile(
                  title: const Text('Recent Searches'),
                  trailing: TextButton(
                    onPressed: () {
                      // TODO: Clear recent searches
                    },
                    child: const Text('Clear All'),
                  ),
                ),
                // TODO: Add recent searches list

                // Popular Searches
                const ListTile(
                  title: Text('Popular Searches'),
                ),
                // TODO: Add popular searches grid
              ],
            ),
    );
  }
}
