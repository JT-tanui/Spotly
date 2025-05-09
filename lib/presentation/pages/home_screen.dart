import 'package:flutter/material.dart';
import 'list_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isListView = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleView() {
    setState(() {
      _isListView = !_isListView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spotly'),
        actions: [
          IconButton(
            icon: Icon(_isListView ? Icons.map : Icons.list),
            onPressed: _toggleView,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Nearby Places'),
            Tab(text: 'My Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _isListView ? const ListScreen() : const MapScreen(),
          _isListView
              ? const ListScreen(showEvents: true)
              : const MapScreen(showEvents: true),
        ],
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add-event');
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
