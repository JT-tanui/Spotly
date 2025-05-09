import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../../core/network/network_info.dart';
import '../../core/services/location_service.dart';
import '../../data/datasources/local/event_local_data_source.dart';
import '../../data/datasources/remote/places_remote_data_source.dart';
import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../data/repositories/places_repository_impl.dart';
import '../../domain/repositories/event_repository.dart';
import '../../domain/repositories/places_repository.dart';
import '../../domain/usecases/get_nearby_places.dart';
import '../../domain/usecases/get_user_events.dart';
import '../../domain/usecases/create_event.dart';
import '../../domain/usecases/update_event.dart';
import '../../domain/usecases/delete_event.dart';
import '../../presentation/blocs/event_bloc/event_bloc.dart';
import '../../presentation/blocs/location_bloc/location_bloc.dart';

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
  getIt.registerLazySingleton(() => Hive.box<EventModel>('events'));

  // Data sources
  getIt.registerLazySingleton<PlacesRemoteDataSource>(
    () => PlacesRemoteDataSourceImpl(
      dio: getIt(),
      apiKey: const String.fromEnvironment('GOOGLE_MAPS_API_KEY'),
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
  getIt.registerFactory(() => EventBloc(
        getUserEvents: getIt(),
        createEvent: getIt(),
        updateEvent: getIt(),
        deleteEvent: getIt(),
      ));
  getIt.registerFactory(() => LocationBloc(locationService: getIt()));
}
