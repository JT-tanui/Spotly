import 'package:flutter/material.dart';
import 'dart:async';

class PromotionalBanner extends StatefulWidget {
  final List<PromoItem> promoItems;
  final double height;
  final double borderRadius;
  final Duration autoScrollDuration;
  final EdgeInsetsGeometry margin;

  const PromotionalBanner({
    super.key,
    required this.promoItems,
    this.height = 180,
    this.borderRadius = 16,
    this.autoScrollDuration = const Duration(seconds: 5),
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  @override
  State<PromotionalBanner> createState() => _PromotionalBannerState();
}

class _PromotionalBannerState extends State<PromotionalBanner> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(widget.autoScrollDuration, (timer) {
      if (_currentPage < widget.promoItems.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: widget.margin,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.promoItems.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return _PromoCard(
                  item: widget.promoItems[index],
                  borderRadius: widget.borderRadius,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.promoItems.length,
              (index) => _buildDot(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);

    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? primaryColor
            : (isDark ? Colors.white24 : Colors.black12),
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  final PromoItem item;
  final double borderRadius;

  const _PromoCard({
    required this.item,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: item.backgroundColor ??
                        (isDark
                            ? const Color(0xFF1E1E1E)
                            : const Color(0xFFF5F5F5)),
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: isDark ? Colors.white30 : Colors.black12,
                        size: 48,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Tag
                  if (item.tag != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: item.tagColor?.withOpacity(0.9) ??
                            (isDark
                                ? const Color(0xFFFF8966)
                                : const Color(0xFFFF6A3D)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.tag!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Sora',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),

                  // Title
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Sora',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Subtitle
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontFamily: 'Inter',
                      fontSize: 14,
                      shadows: const [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black38,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // CTA Button
                  if (item.ctaText != null)
                    ElevatedButton(
                      onPressed: item.onCtaTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: item.ctaColor ??
                            (isDark
                                ? const Color(0xFFFF8966)
                                : const Color(0xFFFF6A3D)),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        item.ctaText!,
                        style: const TextStyle(
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

class PromoItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String? tag;
  final String? ctaText;
  final VoidCallback? onCtaTap;
  final Color? backgroundColor;
  final Color? tagColor;
  final Color? ctaColor;

  const PromoItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.tag,
    this.ctaText,
    this.onCtaTap,
    this.backgroundColor,
    this.tagColor,
    this.ctaColor,
  });
}

class SocialProofTag extends StatelessWidget {
  final int friendsCount;
  final List<String> friendAvatars;
  final VoidCallback onTap;

  const SocialProofTag({
    super.key,
    required this.friendsCount,
    required this.friendAvatars,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar stack
            SizedBox(
              width: friendAvatars.length > 0 ? 60 : 0,
              height: 24,
              child: Stack(
                children: [
                  for (int i = 0; i < friendAvatars.length && i < 3; i++)
                    Positioned(
                      left: i * 16.0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isDark ? const Color(0xFF1E1E1E) : Colors.white,
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: AssetImage(friendAvatars[i]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Icon and text
            if (friendAvatars.length > 0) const SizedBox(width: 8),
            Icon(
              Icons.people,
              size: 16,
              color: primaryColor,
            ),
            const SizedBox(width: 4),
            Text(
              '$friendsCount friends going',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReferralBanner extends StatelessWidget {
  final VoidCallback onTap;
  final int earnPoints;

  const ReferralBanner({
    super.key,
    required this.onTap,
    this.earnPoints = 200,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);
    final accentColor =
        isDark ? const Color(0xFFFF8966) : const Color(0xFFFF6A3D);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.9),
            accentColor.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.share,
                  color: primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Refer & Earn',
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Invite friends to get $earnPoints points',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Share Your Invite Link',
              style: TextStyle(
                fontFamily: 'Sora',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteSpotBadge extends StatelessWidget {
  final String spotName;
  final int visitCount;
  final VoidCallback onTap;

  const FavoriteSpotBadge({
    super.key,
    required this.spotName,
    required this.visitCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor =
        isDark ? const Color(0xFF27EAA5) : const Color(0xFF1BC47D);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: successColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: successColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite,
              color: successColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Spot You Love',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: successColor,
                  ),
                ),
                Text(
                  '$spotName • $visitCount visits',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
