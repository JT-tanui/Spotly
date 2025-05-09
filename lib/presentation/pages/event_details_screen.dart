import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/event.dart';
import '../blocs/event_bloc/event_bloc.dart';
import '../blocs/event_bloc/event_event.dart';
import '../blocs/event_bloc/event_state.dart';
import '../widgets/event_edit_sheet.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: Load event details
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        if (state is EventLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is EventLoaded) {
          final event = state.events.firstWhere(
            (e) => e.id == widget.eventId,
            orElse: () => throw Exception('Event not found'),
          );
          return _buildEventDetails(event);
        } else if (state is EventError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement retry
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        return const Scaffold(
          body: Center(child: Text('No event data available')),
        );
      },
    );
  }

  Widget _buildEventDetails(Event event) {
    final dateFormat = DateFormat('MMM d, y');
    final timeFormat = DateFormat('h:mm a');

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => EventEditSheet(event: event),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Event'),
                  content: const Text(
                    'Are you sure you want to delete this event? This action cannot be undone.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<EventBloc>()
                            .add(DeleteEventEvent(event.id));
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Return to previous screen
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  event.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 48),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              event.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              event.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _buildInfoRow(
              Icons.calendar_today,
              'Date',
              '${dateFormat.format(event.startTime)} - ${dateFormat.format(event.endTime)}',
            ),
            _buildInfoRow(
              Icons.access_time,
              'Time',
              '${timeFormat.format(event.startTime)} - ${timeFormat.format(event.endTime)}',
            ),
            _buildInfoRow(
              Icons.location_on,
              'Location',
              event.address,
            ),
            if (event.price != null)
              _buildInfoRow(
                Icons.attach_money,
                'Price',
                '\$${event.price!.toStringAsFixed(2)}',
              ),
            if (event.maxAttendees != null)
              _buildInfoRow(
                Icons.people,
                'Max Attendees',
                event.maxAttendees.toString(),
              ),
            if (event.contactInfo != null)
              _buildInfoRow(
                Icons.contact_phone,
                'Contact',
                event.contactInfo!,
              ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: event.categories.map((category) {
                return Chip(
                  label: Text(category.name),
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement join event
                },
                icon: const Icon(Icons.add),
                label: const Text('Join Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
