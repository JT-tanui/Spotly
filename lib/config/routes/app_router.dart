import 'package:flutter/material.dart';
import '../../presentation/pages/main/splash_screen.dart';
import '../../presentation/pages/home/spotly_home.dart';
import '../../presentation/pages/events/add_event_screen.dart';
import '../../presentation/pages/events/event_details_screen.dart';
import '../../presentation/pages/map/map_page.dart';
import '../../presentation/pages/profile/profile_screen.dart';
import '../../presentation/pages/auth/sign_up_screen.dart';
import '../../presentation/pages/auth/sign_in_screen.dart';
import '../../presentation/pages/auth/forgot_password_screen.dart';
import '../../presentation/pages/profile/edit_profile_screen.dart';
import '../../presentation/pages/events/my_events_screen.dart';
import '../../presentation/pages/events/saved_events_screen.dart';
import '../../presentation/pages/profile/settings_screen.dart';
import '../../presentation/pages/explore/explore_page.dart';
import '../../presentation/pages/explore/search_page.dart';
import '../../domain/entities/user.dart';

class AppRouter {
  static const String initialRoute = '/';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String search = '/search';
  static const String addEvent = '/add-event';
  static const String eventDetails = '/event-details';
  static const String map = '/map';
  static const String profile = '/profile';
  static const String signUp = '/sign-up';
  static const String signIn = '/sign-in';
  static const String forgotPassword = '/forgot-password';
  static const String editProfile = '/edit-profile';
  static const String myEvents = '/my-events';
  static const String savedEvents = '/saved-events';
  static const String settings = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        // Check if we have a tab index passed as an argument
        final tabIndex = settings.arguments as int?;
        return MaterialPageRoute(
            builder: (_) => tabIndex != null
                ? SpotlyHome(initialTabIndex: tabIndex)
                : const SplashScreen());
      case home:
        // Check if we have a tab index passed as an argument
        final tabIndex = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
            builder: (_) => SpotlyHome(initialTabIndex: tabIndex));
      case explore:
        return MaterialPageRoute(builder: (_) => const ExplorePage());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case addEvent:
        return MaterialPageRoute(builder: (_) => const AddEventScreen());
      case eventDetails:
        final eventId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => EventDetailsScreen(eventId: eventId),
        );
      case map:
        return MaterialPageRoute(
          builder: (_) => const MapPage(),
        );
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case editProfile:
        final user = settings.arguments as User;
        return MaterialPageRoute(
          builder: (_) => EditProfileScreen(user: user),
        );
      case myEvents:
        return MaterialPageRoute(builder: (_) => const MyEventsScreen());
      case savedEvents:
        return MaterialPageRoute(builder: (_) => const SavedEventsScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
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
