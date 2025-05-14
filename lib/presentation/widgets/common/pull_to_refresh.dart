import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PullToRefresh extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;
  final double displacement;
  final double edgeOffset;

  const PullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.displacement = 40.0,
    this.edgeOffset = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color ?? Theme.of(context).primaryColor,
      displacement: displacement,
      edgeOffset: edgeOffset,
      child: child,
    );
  }
}
