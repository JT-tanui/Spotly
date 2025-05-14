import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// App Config
import 'config/firebase/firebase_service.dart';
import 'config/injection/injection.dart';
import 'config/injection/auth_injection.dart';
import 'config/theme/app_theme.dart';
import 'config/theme/font_downloader.dart';
import 'config/routes/app_router.dart';
import 'config/core/app_config.dart';

// Blocs
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'presentation/blocs/location_bloc/location_bloc.dart';
import 'presentation/blocs/event_bloc/event_bloc.dart';
import 'presentation/blocs/places_bloc/places_bloc.dart';
import 'presentation/blocs/explore_bloc/explore_bloc.dart';
import 'presentation/blocs/explore_bloc/explore_bloc_impl.dart';
import 'presentation/blocs/shared_data_bloc/shared_data_bloc.dart';

// Models for Hive adapters
import 'data/models/user_model.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Set up error handling first
    _setupErrorHandling();

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Load environment variables
    try {
      await dotenv.load(fileName: '.env');
      debugPrint('Environment variables loaded successfully');
    } catch (e) {
      debugPrint('Failed to load environment variables: $e');
      // Set default values for required environment variables
      dotenv.env['APP_ENV'] = 'development';
      dotenv.env['DEBUG_MODE'] = 'true';
      debugPrint('Using default environment variables');
    }

    // Initialize app configuration
    try {
      AppConfig.initialize();
      debugPrint('App configuration initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize app configuration: $e');
      // Continue without app configuration in debug mode
    }

    // Initialize Firebase with our service
    try {
      await FirebaseService.initialize();
      debugPrint('Firebase initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize Firebase: $e');
      // Continue without Firebase in debug mode
    }

    // Initialize Hive for local storage
    try {
      await Hive.initFlutter();
      await Hive.openBox('userBox');
      debugPrint('Hive initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize Hive: $e');
      debugPrint('Using SharedPreferences-based user storage instead of Hive');
    }

    // Preload Google Fonts
    try {
      await AppFonts.loadFonts();
      debugPrint('Fonts loaded successfully');
    } catch (e) {
      debugPrint('Failed to load fonts: $e, continuing with system fonts');
    }

    // Initialize dependency injection
    try {
      configureDependencies();
      configureAuthDependencies();
      debugPrint('Dependency injection configured successfully');
    } catch (e) {
      debugPrint('Failed to configure dependencies: $e');
      // Show error screen if dependency injection fails
      runApp(_buildErrorApp('Failed to initialize app dependencies'));
      return;
    }

    // Request permissions
    try {
      await [
        Permission.location,
        Permission.storage,
        Permission.camera,
      ].request();
      debugPrint('Permissions requested successfully');
    } catch (e) {
      debugPrint('Failed to request permissions: $e');
      // Continue without permissions in debug mode
    }

    runApp(const SpotlyApp());
  } catch (e, stackTrace) {
    debugPrint('Fatal error during app initialization: $e');
    debugPrint('Stack trace: $stackTrace');
    runApp(_buildErrorApp('Failed to initialize app: $e'));
  }
}

/// Set up global error handling
void _setupErrorHandling() {
  // Catch Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('Flutter error: ${details.exception}');
    debugPrint(details.stack.toString());
    // In release mode, report to a crash reporting service
    // In debug mode, rethrow to see the error in the console
    if (dotenv.env['APP_ENV'] == 'production') {
      // TODO: Report to crash reporting service
    } else {
      FlutterError.dumpErrorToConsole(details);
    }
  };

  // Catch async errors that aren't caught by the Flutter framework
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Uncaught platform error: $error');
    debugPrint(stack.toString());
    // In release mode, report to a crash reporting service
    // Return true to prevent the error from being propagated
    return true;
  };
}

/// Fallback error app to show if the main app fails to initialize
Widget _buildErrorApp(String errorMessage) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Attempt to restart the app
                  main();
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> _requestPermissions() async {
  await Permission.location.request();
  await Permission.notification.request();
}

class SpotlyApp extends StatelessWidget {
  const SpotlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Handle possible exceptions with dependency injection
    final providers = <BlocProvider>[];

    try {
      final authBloc = getIt<AuthBloc>();
      authBloc.add(CheckAuthStatusEvent());
      providers.add(
        BlocProvider<AuthBloc>(
          create: (context) => authBloc,
        ),
      );
    } catch (e) {
      debugPrint('Failed to get AuthBloc: $e');
    }

    try {
      final locationBloc = LocationBloc();
      providers.add(
        BlocProvider<LocationBloc>(
          create: (context) => locationBloc,
        ),
      );
    } catch (e) {
      debugPrint('Failed to get LocationBloc: $e');
    }

    try {
      final eventBloc = getIt<EventBloc>();
      providers.add(
        BlocProvider<EventBloc>(
          create: (context) => eventBloc,
        ),
      );
    } catch (e) {
      debugPrint('Failed to get EventBloc: $e');
    }

    try {
      final placesBloc = getIt<PlacesBloc>();
      providers.add(
        BlocProvider<PlacesBloc>(
          create: (context) => placesBloc,
        ),
      );
    } catch (e) {
      debugPrint('Failed to get PlacesBloc: $e');
    }

    try {
      // Add ExploreBloc provider - even though it may not be in getIt,
      // we can still provide it directly
      providers.add(
        BlocProvider<ExploreBloc>(
          create: (context) => ExploreBloc(),
        ),
      );
    } catch (e) {
      debugPrint('Failed to create ExploreBloc: $e');
    }

    try {
      // Add SharedDataBloc - this is our bridge between Map and Explore pages
      final sharedDataBloc = getIt<SharedDataBloc>();
      providers.add(
        BlocProvider<SharedDataBloc>(
          create: (context) => sharedDataBloc,
        ),
      );
    } catch (e) {
      debugPrint('Failed to get SharedDataBloc: $e');
    }

    return MultiBlocProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Spotly',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRouter.initialRoute,
        onGenerateRoute: AppRouter.onGenerateRoute,
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          // Add a navigator observer to log route changes
          _RouteObserver(),
        ],
        // Add an error builder for routes that fail to load
        builder: (context, child) {
          // Apply font scaling restrictions
          return MediaQuery(
            // Prevent font scaling to break the UI
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.0,
              // Set a platform-specific padding
              padding: MediaQuery.of(context).padding,
            ),
            child: child ?? Container(),
          );
        },
      ),
    );
  }
}

/// Custom route observer to log navigation
class _RouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('Route pushed: ${route.settings.name}');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('Route popped: ${route.settings.name}');
    super.didPop(route, previousRoute);
  }
}
