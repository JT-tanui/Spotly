import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:dio/dio.dart';

import 'config/app_config.dart';
import 'core/network/network_info.dart';
import 'data/datasources/local/event_local_data_source.dart';
import 'data/datasources/remote/places_remote_data_source.dart';
import 'data/models/event_model.dart';
import 'data/repositories/event_repository_impl.dart';
import 'data/repositories/places_repository_impl.dart';
import 'domain/repositories/event_repository.dart';
import 'domain/repositories/places_repository.dart';
import 'domain/usecases/get_nearby_places.dart';
import 'domain/usecases/get_user_events.dart';
import 'domain/usecases/create_event.dart';
import 'domain/usecases/update_event.dart';
import 'domain/usecases/delete_event.dart';
import 'presentation/blocs/event_bloc/event_bloc.dart';
import 'presentation/blocs/places_bloc/places_bloc.dart';
import 'presentation/pages/splash_screen.dart';
import 'presentation/pages/home_screen.dart';
import 'presentation/pages/add_event_screen.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');
  AppConfig.initialize(googleMapsKey: dotenv.env['GOOGLE_MAPS_API_KEY']!);

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(EventModelAdapter());
  await Hive.openBox<EventModel>(AppConfig.eventsBoxName);

  // Register dependencies
  _registerDependencies();

  runApp(const MyApp());
}

void _registerDependencies() {
  // Core
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(InternetConnectionChecker()),
  );

  // External
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(
      () => Hive.box<EventModel>(AppConfig.eventsBoxName));

  // Data sources
  getIt.registerLazySingleton<PlacesRemoteDataSource>(
    () => PlacesRemoteDataSourceImpl(
      dio: getIt(),
      apiKey: AppConfig.googleMapsApiKey,
    ),
  );
  getIt.registerLazySingleton<EventLocalDataSource>(
    () => EventLocalDataSourceImpl(eventsBox: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<PlacesRepository>(
    () => PlacesRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  getIt.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(localDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetNearbyPlaces(getIt()));
  getIt.registerLazySingleton(() => GetUserEvents(getIt()));
  getIt.registerLazySingleton(() => CreateEvent(getIt()));
  getIt.registerLazySingleton(() => UpdateEvent(getIt()));
  getIt.registerLazySingleton(() => DeleteEvent(getIt()));

  // BLoCs
  getIt.registerFactory(() => PlacesBloc(getNearbyPlaces: getIt()));
  getIt.registerFactory(() => EventBloc(
        getUserEvents: getIt(),
        createEvent: getIt(),
        updateEvent: getIt(),
        deleteEvent: getIt(),
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<PlacesBloc>()),
        BlocProvider(create: (_) => getIt<EventBloc>()),
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6200EE)),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
          '/add-event': (context) => const AddEventScreen(),
        },
      ),
    );
  }
}
