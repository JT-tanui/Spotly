import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

import 'config/injection/injection.dart';
import 'config/app_router.dart';
import 'config/app_theme.dart';
import 'config/firebase/firebase_service.dart';
import 'presentation/blocs/event_bloc/event_bloc.dart';
import 'presentation/blocs/location_bloc/location_bloc.dart';
import 'presentation/blocs/places_bloc/places_bloc.dart';
import 'domain/usecases/get_user_events.dart';
import 'domain/usecases/create_event.dart';
import 'domain/usecases/update_event.dart';
import 'domain/usecases/delete_event.dart';
import 'core/services/location_service.dart';
import 'domain/usecases/get_nearby_places.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Hive
  await Hive.initFlutter();
  // TODO: Register Hive adapters

  // Initialize Firebase
  await FirebaseService.initialize();
  FirebaseMessaging.onBackgroundMessage(
      FirebaseService.handleBackgroundMessage);
  FirebaseMessaging.onMessage.listen(FirebaseService.handleForegroundMessage);

  // Configure dependency injection
  await configureDependencies();

  // Request necessary permissions
  await _requestPermissions();

  runApp(const MyApp());
}

Future<void> _requestPermissions() async {
  await Permission.location.request();
  await Permission.notification.request();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EventBloc(
            getUserEvents: getIt<GetUserEvents>(),
            createEvent: getIt<CreateEvent>(),
            updateEvent: getIt<UpdateEvent>(),
            deleteEvent: getIt<DeleteEvent>(),
          ),
        ),
        BlocProvider(
          create: (context) => LocationBloc(
            locationService: getIt<LocationService>(),
          ),
        ),
        BlocProvider(
          create: (context) => PlacesBloc(
            getNearbyPlaces: getIt<GetNearbyPlaces>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Spotly',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        onGenerateRoute: AppRouter.generateRoute,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
      ),
    );
  }
}
