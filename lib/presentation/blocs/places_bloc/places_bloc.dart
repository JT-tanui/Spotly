import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/place.dart';
import '../../../domain/usecases/get_nearby_places.dart';

part 'places_event.dart';
part 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  final GetNearbyPlaces getNearbyPlaces;

  PlacesBloc({required this.getNearbyPlaces}) : super(PlacesInitial()) {
    on<LoadNearbyPlaces>(_onLoadNearbyPlaces);
  }

  Future<void> _onLoadNearbyPlaces(
    LoadNearbyPlaces event,
    Emitter<PlacesState> emit,
  ) async {
    emit(PlacesLoading());

    final result = await getNearbyPlaces(
      GetNearbyPlacesParams(
        latitude: event.latitude,
        longitude: event.longitude,
        radius: event.radius,
      ),
    );

    result.fold(
      (failure) => emit(PlacesError(message: 'Failed to load places')),
      (places) => emit(PlacesLoaded(places: places)),
    );
  }
}
