import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
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
