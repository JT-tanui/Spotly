import 'package:flutter/material.dart';
import '../shimmer_loading.dart';

class EventCardShimmer extends StatelessWidget {
  const EventCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: ShimmerLoading(
              height: 160,
              width: double.infinity,
            ),
          ),

          // Content section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title placeholder
                ShimmerLoading(
                  height: 24,
                  width: double.infinity,
                  borderRadius: 4,
                ),
                const SizedBox(height: 16),

                // Date placeholder
                Row(
                  children: [
                    ShimmerLoading(
                      height: 16,
                      width: 16,
                      borderRadius: 8,
                    ),
                    const SizedBox(width: 8),
                    ShimmerLoading(
                      height: 16,
                      width: 150,
                      borderRadius: 4,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Location placeholder
                Row(
                  children: [
                    ShimmerLoading(
                      height: 16,
                      width: 16,
                      borderRadius: 8,
                    ),
                    const SizedBox(width: 8),
                    ShimmerLoading(
                      height: 16,
                      width: 180,
                      borderRadius: 4,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Attendance placeholder
                ShimmerLoading(
                  height: 4,
                  width: double.infinity,
                  borderRadius: 2,
                ),
                const SizedBox(height: 8),
                ShimmerLoading(
                  height: 14,
                  width: 120,
                  borderRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
