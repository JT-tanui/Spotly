import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoading({
    Key? key,
    required this.height,
    this.width,
    this.borderRadius = 0,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: baseColor ?? theme.colorScheme.surfaceVariant,
      highlightColor: highlightColor ?? theme.colorScheme.surface,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class EventCardShimmer extends StatelessWidget {
  const EventCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerLoading(
              height: 200,
              borderRadius: 8,
            ),
            const SizedBox(height: 16),
            const ShimmerLoading(
              width: 200,
              height: 24,
            ),
            const SizedBox(height: 8),
            const ShimmerLoading(
              height: 16,
            ),
            const SizedBox(height: 8),
            const ShimmerLoading(
              height: 16,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const ShimmerLoading(
                  width: 100,
                  height: 16,
                ),
                const SizedBox(width: 16),
                const ShimmerLoading(
                  width: 100,
                  height: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceCardShimmer extends StatelessWidget {
  const PlaceCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const ShimmerLoading(
              width: 80,
              height: 80,
              borderRadius: 8,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerLoading(
                    width: 150,
                    height: 20,
                  ),
                  const SizedBox(height: 8),
                  const ShimmerLoading(
                    height: 16,
                  ),
                  const SizedBox(height: 8),
                  const ShimmerLoading(
                    width: 100,
                    height: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
