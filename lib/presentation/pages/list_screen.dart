import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/places_bloc/places_bloc.dart';
import '../blocs/event_bloc/event_bloc.dart';
import '../blocs/event_bloc/event_state.dart';
import '../blocs/event_bloc/event_event.dart';
import '../widgets/event_card.dart';

class ListScreen extends StatelessWidget {
  final bool showEvents;

  const ListScreen({super.key, this.showEvents = false});

  @override
  Widget build(BuildContext context) {
    return showEvents ? _buildEventsList() : _buildPlacesList();
  }

  Widget _buildPlacesList() {
    return BlocBuilder<PlacesBloc, PlacesState>(
      builder: (context, state) {
        if (state is PlacesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PlacesLoaded) {
          if (state.places.isEmpty) {
            return _buildEmptyState(
              context,
              'No places found',
              'Try searching in a different area',
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              // TODO: Implement refresh
            },
            child: ListView.builder(
              itemCount: state.places.length,
              itemBuilder: (context, index) {
                final place = state.places[index];
                return ListTile(
                  leading: const Icon(Icons.place),
                  title: Text(place.name),
                  subtitle: Text(place.address),
                  trailing: place.rating != null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star,
                                size: 20, color: Colors.amber),
                            Text(place.rating!.toString()),
                          ],
                        )
                      : null,
                  onTap: () {
                    // TODO: Show place details
                  },
                );
              },
            ),
          );
        } else if (state is PlacesError) {
          return _buildErrorState(
            context,
            state.message,
            () {
              // TODO: Implement retry
            },
          );
        }
        return _buildEmptyState(
          context,
          'No places found',
          'Try searching in a different area',
        );
      },
    );
  }

  Widget _buildEventsList() {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        if (state is EventLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EventLoaded) {
          if (state.events.isEmpty) {
            return _buildEmptyState(
              context,
              'No events found',
              'Create your first event or join an existing one',
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              // TODO: Get current user ID
              const userId = 'current_user_id';
              context.read<EventBloc>().add(GetUserEventsEvent(userId));
            },
            child: ListView.builder(
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                final event = state.events[index];
                return EventCard(event: event);
              },
            ),
          );
        } else if (state is EventError) {
          return _buildErrorState(
            context,
            state.message,
            () {
              // TODO: Get current user ID
              const userId = 'current_user_id';
              context.read<EventBloc>().add(GetUserEventsEvent(userId));
            },
          );
        }
        return _buildEmptyState(
          context,
          'No events found',
          'Create your first event or join an existing one',
        );
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            showEvents ? Icons.event_busy : Icons.place,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String message,
    VoidCallback onRetry,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            showEvents ? Icons.error_outline : Icons.place,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
