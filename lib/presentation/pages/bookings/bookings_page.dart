import 'package:flutter/material.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Text(
              'Your Bookings',
              style: TextStyle(
                fontFamily: 'Sora',
                color:
                    isDark ? const Color(0xFFFAFAFA) : const Color(0xFF111111),
              ),
            ),
            backgroundColor:
                isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F8FC),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upcoming Events',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? const Color(0xFFFAFAFA)
                          : const Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Placeholder for upcoming events
                  _buildEmptyState(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF),
          ),
          const SizedBox(height: 16),
          Text(
            'No Bookings Yet',
            style: TextStyle(
              fontFamily: 'Sora',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFFAFAFA) : const Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your upcoming events will appear here',
            style: TextStyle(
              fontFamily: 'Inter',
              color: isDark ? const Color(0xFFB3B3B3) : const Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to explore page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Explore Events',
              style: TextStyle(
                fontFamily: 'Sora',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
