import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/places_bloc/places_bloc.dart';
import '../blocs/event_bloc/event_bloc.dart';
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
          return ListView.builder(
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
                          const Icon(Icons.star, size: 20, color: Colors.amber),
                          Text(place.rating!.toString()),
                        ],
                      )
                    : null,
                onTap: () {
                  // TODO: Show place details
                },
              );
            },
          );
        } else if (state is PlacesError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('No places found'));
      },
    );
  }

  Widget _buildEventsList() {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        if (state is EventsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EventsLoaded) {
          return ListView.builder(
            itemCount: state.events.length,
            itemBuilder: (context, index) {
              final event = state.events[index];
              return EventCard(event: event);
            },
          );
        } else if (state is EventsError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('No events found'));
      },
    );
  }
}
