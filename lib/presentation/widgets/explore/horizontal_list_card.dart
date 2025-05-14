import 'package:flutter/material.dart';
import 'package:spotly/domain/entities/place.dart';
import 'package:spotly/domain/entities/event.dart';

class HorizontalListCard extends StatelessWidget {
  final List<dynamic> items;
  final Function(dynamic) onItemTap;

  const HorizontalListCard({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          // Get properties with null safety
          final String imageUrl = _getImageUrl(item);
          final String title = _getTitle(item);
          final String category = _getCategory(item);
          final String location = _getLocation(item);

          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => onItemTap(item),
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildImagePlaceholder(context);
                                },
                              )
                            : _buildImagePlaceholder(context),
                      ),
                    ),
                    // Details
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  location,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
            ),
          );
        },
      ),
    );
  }

  // Helper methods for safe property access
  String _getImageUrl(dynamic item) {
    if (item is Place) {
      return item.imageUrl.isNotEmpty ? item.imageUrl : '';
    } else if (item is Event) {
      return item.imageUrl.isNotEmpty ? item.imageUrl : '';
    }
    return '';
  }

  String _getTitle(dynamic item) {
    if (item is Place) {
      return item.name;
    } else if (item is Event) {
      return item.title;
    }
    return 'Unknown';
  }

  String _getCategory(dynamic item) {
    if (item is Event) {
      return item.categories.isNotEmpty
          ? item.categories.first
          : 'Uncategorized';
    } else if (item is Place) {
      return item.category.isNotEmpty ? item.category : 'Uncategorized';
    }
    return 'Uncategorized';
  }

  String _getLocation(dynamic item) {
    if (item is Place) {
      return item.address.isNotEmpty ? item.address : 'Location unavailable';
    } else if (item is Event) {
      return item.location.isNotEmpty ? item.location : 'Location unavailable';
    }
    return 'Location unavailable';
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }
}
