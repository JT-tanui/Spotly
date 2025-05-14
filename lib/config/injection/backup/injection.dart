import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/network/network_info.dart';
import '../../core/services/location_service.dart';
import '../../data/datasources/local/event_local_data_source.dart';
import '../../data/datasources/event_remote_datasource.dart';
import '../../data/datasources/remote/places_remote_data_source.dart';
import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../data/repositories/places_repository_impl.dart';
import '../../domain/repositories/event_repository.dart';
import '../../domain/repositories/places_repository.dart';
import '../../domain/usecases/get_nearby_places.dart';
import '../../domain/usecases/get_nearby_events.dart';
import '../../domain/usecases/get_user_events.dart';
import '../../domain/usecases/create_event.dart';
import '../../domain/usecases/update_event.dart';
import '../../domain/usecases/delete_event.dart';
import '../../domain/usecases/get_featured_events.dart';
import '../../domain/usecases/get_upcoming_events.dart';
import '../../presentation/blocs/event_bloc/event_bloc.dart';
import '../../presentation/blocs/location_bloc/location_bloc.dart';
import '../../presentation/blocs/explore_bloc/explore_bloc.dart';
import '../../presentation/blocs/explore_bloc/explore_bloc_impl.dart';
import '../../presentation/blocs/places_bloc/places_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Core
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(InternetConnectionChecker()),
  );
  getIt.registerLazySingleton<LocationService>(
    () => LocationService(),
  );

  // External
  getIt.registerLazySingleton(() => Dio());

  // SharedPreferences for local storage
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Register a dummy Hive box for events to be used with mock data
  try {
    final box = await Hive.openBox<EventModel>('events');
    getIt.registerLazySingleton<Box<EventModel>>(() => box);
  } catch (e) {
    // If Hive isn't initialized yet or errors occur, create a dummy box registration
    print('Warning: Using dummy Hive box for events due to error: $e');
    getIt.registerLazySingleton<Box<EventModel>>(
        () => throw UnimplementedError('Hive not initialized'));
  }

  // Data sources
  getIt.registerLazySingleton<PlacesRemoteDataSource>(
    () => PlacesRemoteDataSourceImpl(
      dio: getIt(),
      apiKey: const String.fromEnvironment('GOOGLE_MAPS_API_KEY'),
    ),
  );
  getIt.registerLazySingleton<EventLocalDataSource>(
    () => EventLocalDataSourceImpl(
      eventsBox: getIt(),
      useMockData: true, // Use mock data for development
    ),
  );
  getIt.registerLazySingleton<EventRemoteDataSource>(
    () => EventRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
      currentUserId:
          'temp_user_id', // TODO: Replace with actual user ID from auth
    ),
  );

  // Repositories
  getIt.registerLazySingleton<PlacesRepository>(
    () => PlacesRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  getIt.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      firestore: FirebaseFirestore.instance,
      networkInfo: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetNearbyPlaces(getIt()));
  getIt.registerLazySingleton(() => GetUserEvents(getIt()));
  getIt.registerLazySingleton(() => CreateEvent(getIt()));
  getIt.registerLazySingleton(() => UpdateEvent(getIt()));
  getIt.registerLazySingleton(() => DeleteEvent(getIt()));
  getIt.registerLazySingleton(() => GetFeaturedEvents(getIt()));
  getIt.registerLazySingleton(() => GetUpcomingEvents(getIt()));
  getIt.registerLazySingleton(() => GetNearbyEvents(getIt()));

  // BLoCs
  getIt.registerFactory(
    () => EventBloc(getIt()),
  );
  getIt.registerFactory(() => LocationBloc(locationService: getIt()));
  getIt.registerFactory(() => PlacesBloc(getNearbyPlaces: getIt()));
  getIt.registerFactory(() => ExploreBlocImpl(
        getFeaturedEvents: getIt(),
        getUpcomingEvents: getIt(),
        eventRepository: getIt(),
        venueRepository: getIt(),
      ));
}
