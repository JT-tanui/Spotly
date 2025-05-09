import 'package:flutter/material.dart';
import '../../presentation/pages/splash_screen.dart';
import '../../presentation/pages/home_screen.dart';
import '../../presentation/pages/add_event_screen.dart';
import '../../presentation/pages/event_details_screen.dart';
import '../../presentation/pages/map_screen.dart';
import '../../presentation/pages/profile_screen.dart';

class AppRouter {
  static const String initialRoute = '/';
  static const String home = '/home';
  static const String addEvent = '/add-event';
  static const String eventDetails = '/event-details';
  static const String map = '/map';
  static const String profile = '/profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case addEvent:
        return MaterialPageRoute(builder: (_) => const AddEventScreen());
      case eventDetails:
        final eventId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => EventDetailsScreen(eventId: eventId),
        );
      case map:
        return MaterialPageRoute(builder: (_) => const MapScreen());
      case profile:
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
