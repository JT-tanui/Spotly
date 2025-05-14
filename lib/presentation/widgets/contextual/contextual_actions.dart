import 'package:flutter/material.dart';

enum ActionType {
  trending,
  recommended,
  mapPinAction,
  bookingStatus,
  profileStats,
}

class ContextualAction {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final ActionType type;
  final String? subtitle;
  final Widget? trailing;

  const ContextualAction({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.type,
    this.subtitle,
    this.trailing,
  });
}

class ActionBadge extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ActionBadge({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: color,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Sora',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContextualActionList extends StatelessWidget {
  final List<ContextualAction> actions;
  final double spacing;
  final Axis direction;
  final CrossAxisAlignment crossAlignment;

  const ContextualActionList({
    super.key,
    required this.actions,
    this.spacing = 8.0,
    this.direction = Axis.horizontal,
    this.crossAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.horizontal) {
      return SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: actions.length,
          separatorBuilder: (context, index) => SizedBox(width: spacing),
          itemBuilder: (context, index) {
            final action = actions[index];
            return ActionBadge(
              text: action.title,
              icon: action.icon,
              color: action.color,
              onTap: action.onTap,
            );
          },
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: crossAlignment,
        children: actions.map((action) {
          return Padding(
            padding: EdgeInsets.only(bottom: spacing),
            child: _buildActionByType(context, action),
          );
        }).toList(),
      );
    }
  }

  Widget _buildActionByType(BuildContext context, ContextualAction action) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (action.type) {
      case ActionType.trending:
      case ActionType.recommended:
        return ActionBadge(
          text: action.title,
          icon: action.icon,
          color: action.color,
          onTap: action.onTap,
        );

      case ActionType.mapPinAction:
        return ElevatedButton.icon(
          onPressed: action.onTap,
          icon: Icon(action.icon, size: 18),
          label: Text(
            action.title,
            style: const TextStyle(
              fontFamily: 'Sora',
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isDark ? const Color(0xFFFF8966) : const Color(0xFFFF6A3D),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

      case ActionType.bookingStatus:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: action.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: action.color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(action.icon, color: action.color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.title,
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (action.subtitle != null)
                      Text(
                        action.subtitle!,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                  ],
                ),
              ),
              if (action.trailing != null) action.trailing!,
            ],
          ),
        );

      case ActionType.profileStats:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.black12 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action.title,
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (action.subtitle != null)
                    Text(
                      action.subtitle!,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                ],
              ),
              Icon(
                action.icon,
                color: action.color,
                size: 32,
              ),
            ],
          ),
        );
    }
  }
}

// Helper widgets for specific screens
class ExploreActions extends StatelessWidget {
  final VoidCallback onTrendingTap;
  final VoidCallback onRecommendedTap;

  const ExploreActions({
    super.key,
    required this.onTrendingTap,
    required this.onRecommendedTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);
    final accentColor =
        isDark ? const Color(0xFFFF8966) : const Color(0xFFFF6A3D);

    final actions = [
      ContextualAction(
        title: '🔥 Trending Now',
        icon: Icons.whatshot,
        color: accentColor,
        onTap: onTrendingTap,
        type: ActionType.trending,
      ),
      ContextualAction(
        title: '🎯 Recommended for You',
        icon: Icons.recommend,
        color: primaryColor,
        onTap: onRecommendedTap,
        type: ActionType.recommended,
      ),
    ];

    return ContextualActionList(
      actions: actions,
      spacing: 12,
    );
  }
}

class MapPinActions extends StatelessWidget {
  final String placeName;
  final String placeType;
  final bool isSaved;
  final VoidCallback onBookNow;
  final VoidCallback onGetDirections;
  final VoidCallback onSave;

  const MapPinActions({
    super.key,
    required this.placeName,
    required this.placeType,
    required this.isSaved,
    required this.onBookNow,
    required this.onGetDirections,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    placeName,
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    placeType,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: isSaved ? primaryColor : null,
              ),
              onPressed: onSave,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ContextualActionList(
                actions: [
                  ContextualAction(
                    title: 'Book Now',
                    icon: Icons.calendar_today,
                    color: isDark
                        ? const Color(0xFFFF8966)
                        : const Color(0xFFFF6A3D),
                    onTap: onBookNow,
                    type: ActionType.mapPinAction,
                  ),
                ],
                direction: Axis.vertical,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ContextualActionList(
                actions: [
                  ContextualAction(
                    title: 'Get Directions',
                    icon: Icons.directions,
                    color: primaryColor,
                    onTap: onGetDirections,
                    type: ActionType.mapPinAction,
                  ),
                ],
                direction: Axis.vertical,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BookingStatusActions extends StatelessWidget {
  final VoidCallback onUpcomingTap;
  final VoidCallback onPastTap;
  final VoidCallback onViewQRCode;

  const BookingStatusActions({
    super.key,
    required this.onUpcomingTap,
    required this.onPastTap,
    required this.onViewQRCode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);
    final successColor =
        isDark ? const Color(0xFF27EAA5) : const Color(0xFF1BC47D);

    final actions = [
      ContextualAction(
        title: 'Upcoming',
        icon: Icons.event_available,
        color: primaryColor,
        onTap: onUpcomingTap,
        type: ActionType.bookingStatus,
        subtitle: 'Your confirmed reservations',
        trailing: Badge(
          label: const Text('3'),
          backgroundColor: primaryColor,
        ),
      ),
      ContextualAction(
        title: 'Past Events',
        icon: Icons.history,
        color: Colors.grey,
        onTap: onPastTap,
        type: ActionType.bookingStatus,
        subtitle: 'Events you\'ve attended',
      ),
      ContextualAction(
        title: 'My QR Code',
        icon: Icons.qr_code,
        color: successColor,
        onTap: onViewQRCode,
        type: ActionType.bookingStatus,
        subtitle: 'Show at check-in for quick access',
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDark ? Colors.white54 : Colors.black45,
        ),
      ),
    ];

    return ContextualActionList(
      actions: actions,
      spacing: 12,
      direction: Axis.vertical,
    );
  }
}

class ProfileStatsActions extends StatelessWidget {
  final int checkIns;
  final int savedSpots;
  final int points;
  final VoidCallback onCheckInsTap;
  final VoidCallback onSavedTap;
  final VoidCallback onPointsTap;

  const ProfileStatsActions({
    super.key,
    required this.checkIns,
    required this.savedSpots,
    required this.points,
    required this.onCheckInsTap,
    required this.onSavedTap,
    required this.onPointsTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);
    final accentColor =
        isDark ? const Color(0xFFFF8966) : const Color(0xFFFF6A3D);

    final actions = [
      ContextualAction(
        title: '$checkIns Check-ins',
        icon: Icons.place,
        color: primaryColor,
        onTap: onCheckInsTap,
        type: ActionType.profileStats,
        subtitle: 'Places you\'ve visited',
      ),
      ContextualAction(
        title: '$savedSpots Saved',
        icon: Icons.bookmark,
        color: accentColor,
        onTap: onSavedTap,
        type: ActionType.profileStats,
        subtitle: 'Bookmarks & favorites',
      ),
      ContextualAction(
        title: '$points XP',
        icon: Icons.emoji_events,
        color: Colors.amber,
        onTap: onPointsTap,
        type: ActionType.profileStats,
        subtitle: 'Your Spotly points',
      ),
    ];

    return ContextualActionList(
      actions: actions,
      spacing: 16,
      direction: Axis.vertical,
    );
  }
}
