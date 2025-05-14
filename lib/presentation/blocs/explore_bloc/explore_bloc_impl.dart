import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/event_repository.dart';
import '../../../domain/repositories/venue_repository.dart';
import '../../../domain/usecases/get_featured_events.dart';
import '../../../domain/usecases/get_upcoming_events.dart';
import 'explore_bloc.dart';

// Simple implementation that now just forwards to ExploreBloc
class ExploreBlocImpl extends ExploreBloc {
  ExploreBlocImpl({
    required GetFeaturedEvents getFeaturedEvents,
    required GetUpcomingEvents getUpcomingEvents,
    required EventRepository eventRepository,
    required VenueRepository venueRepository,
  }) : super();
}
