import 'package:flutter/material.dart';
import '../presentation/pages/splash_screen.dart';
import '../presentation/pages/home_screen.dart';
import '../presentation/pages/map_screen.dart';
import '../presentation/pages/list_screen.dart';
import '../presentation/pages/event_details_screen.dart';
import '../presentation/pages/profile_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/map':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => MapScreen(
            showEvents: args?['showEvents'] ?? false,
          ),
        );
      case '/list':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ListScreen(
            showEvents: args?['showEvents'] ?? false,
          ),
        );
      case '/event-details':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => EventDetailsScreen(
            eventId: args['eventId'],
          ),
        );
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
