import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EventCardShimmer extends StatelessWidget {
  const EventCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 24,
                width: 200,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                height: 16,
                width: double.infinity,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                height: 16,
                width: 150,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    height: 24,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 24,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    height: 16,
                    width: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 16,
                    width: 150,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    height: 16,
                    width: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 16,
                    width: 200,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
