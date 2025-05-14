import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/event.dart';
import '../blocs/shared_data_bloc/shared_data_bloc.dart';

class UnifiedDetailBottomSheet extends StatelessWidget {
  final dynamic item; // Can be either Place or Event
  final bool showMapButton;

  const UnifiedDetailBottomSheet({
    super.key,
    required this.item,
    this.showMapButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);
    final textSecondary =
        isDark ? const Color(0xFFB5B5B5) : const Color(0xFF6B6B6B);

    final bool isEvent = item is Event;
    final String title = isEvent ? (item as Event).title : (item as Place).name;
    final String imageUrl =
        isEvent ? (item as Event).imageUrl ?? '' : (item as Place).imageUrl;
    final String description =
        isEvent ? (item as Event).description : (item as Place).description;
    final String location =
        isEvent ? (item as Event).location : (item as Place).address;
    final String category = isEvent
        ? ((item as Event).categories.isNotEmpty
            ? (item as Event).categories.first
            : 'Event')
        : (item as Place).category;
    final double rating =
        isEvent ? (item as Event).rating : (item as Place).rating;
    final double latitude =
        isEvent ? (item as Event).latitude : (item as Place).latitude;
    final double longitude =
        isEvent ? (item as Event).longitude : (item as Place).longitude;

    // Check if item is bookmarked
    final String itemId = isEvent ? (item as Event).id : (item as Place).id;
    final bool isBookmarked = context.select<SharedDataBloc, bool>(
        (bloc) => bloc.state.bookmarkedItemIds.contains(itemId));

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header image
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[300],
                              alignment: Alignment.center,
                              child: const Icon(Icons.image, size: 50),
                            );
                          },
                        )
                      : Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: const Icon(Icons.image, size: 50),
                        ),
                ),
                // Close button
                Positioned(
                  top: 16,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.black : Colors.white)
                            .withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back,
                          color: isDark ? Colors.white : Colors.black),
                    ),
                  ),
                ),
                // Category badge and bookmark icon
                Positioned(
                  top: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          context.read<SharedDataBloc>().add(
                                UpdateBookmarkedItems(
                                  itemId: itemId,
                                  isSaving: !isBookmarked,
                                ),
                              );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (isDark ? Colors.black : Colors.white)
                                .withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: isBookmarked
                                ? primaryColor
                                : isDark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sora',
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      if (rating > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Date/Time for events
                  if (isEvent) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          (item as Event).formattedDate,
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.access_time,
                          color: primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          (item as Event).formattedTime,
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inter',
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Additional photos if available for places
                  if (!isEvent &&
                      (item as Place).photos != null &&
                      (item as Place).photos!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Photos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sora',
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: (item as Place).photos!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    (item as Place).photos![index],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey[300],
                                        alignment: Alignment.center,
                                        child: const Icon(Icons.broken_image,
                                            size: 24),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (isEvent)
                        _buildActionButton(
                          context,
                          icon: Icons.event,
                          label: 'RSVP',
                          onTap: () {
                            // Handle RSVP
                            Navigator.pop(context);
                          },
                          isPrimary: true,
                          primaryColor: primaryColor,
                          isDark: isDark,
                        )
                      else
                        _buildActionButton(
                          context,
                          icon: Icons.directions,
                          label: 'Directions',
                          onTap: () {
                            // Handle directions
                            Navigator.pop(context);
                          },
                          isPrimary: true,
                          primaryColor: primaryColor,
                          isDark: isDark,
                        ),

                      // "See on Map" button - only show if specified
                      if (showMapButton)
                        _buildActionButton(
                          context,
                          icon: Icons.map,
                          label: 'See on Map',
                          onTap: () {
                            // Save the selected item to the shared bloc
                            if (isEvent) {
                              context
                                  .read<SharedDataBloc>()
                                  .add(SetSelectedEvent(item as Event));
                            } else {
                              context
                                  .read<SharedDataBloc>()
                                  .add(SetSelectedPlace(item as Place));
                            }

                            // Set map location
                            context.read<SharedDataBloc>().add(
                                  SyncMapLocation(
                                    mapCenter: LatLng(latitude, longitude),
                                    mapZoom: 15.0,
                                  ),
                                );

                            // Navigate to Map page if we're not already there
                            Navigator.pop(context);
                            // Navigation to Map handled by parent
                          },
                          isPrimary: false,
                          primaryColor: primaryColor,
                          isDark: isDark,
                        ),

                      _buildActionButton(
                        context,
                        icon: Icons.share,
                        label: 'Share',
                        onTap: () {
                          // Handle share
                          Navigator.pop(context);
                        },
                        isPrimary: false,
                        primaryColor: primaryColor,
                        isDark: isDark,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
    required Color primaryColor,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isPrimary
                  ? primaryColor
                  : isDark
                      ? Colors.grey[800]
                      : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isPrimary
                  ? Colors.white
                  : isDark
                      ? Colors.white
                      : primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isPrimary
                  ? primaryColor
                  : isDark
                      ? Colors.white70
                      : Colors.grey[800],
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
