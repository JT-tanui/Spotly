import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/entities/event_category.dart';
import '../../blocs/event_bloc/event_bloc.dart';
import '../../blocs/event_bloc/event_event.dart';
import '../../blocs/event_bloc/event_state.dart';

class EventEditSheet extends StatefulWidget {
  final Event event;

  const EventEditSheet({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<EventEditSheet> createState() => _EventEditSheetState();
}

class _EventEditSheetState extends State<EventEditSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _priceController;
  late TextEditingController _maxAttendeesController;
  late TextEditingController _categoryController;
  late DateTime _startDate;
  late DateTime _endDate;
  late bool _isPrivate;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _locationController = TextEditingController(text: widget.event.location);
    _priceController =
        TextEditingController(text: widget.event.price.toString());
    _maxAttendeesController = TextEditingController(
        text: widget.event.maxAttendees?.toString() ?? '0');
    _categoryController =
        TextEditingController(text: widget.event.categories.first);
    _categories = widget.event.categories;
    _startDate = widget.event.startDate;
    _endDate = widget.event.endDate;
    _isPrivate = widget.event.isPrivate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _maxAttendeesController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEE, MMM d, y');
    final timeFormat = DateFormat('h:mm a');

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Drag handle and title
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title
                    Text(
                      'Edit Event',
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),

              // Form fields
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Event image
                    if (widget.event.imageUrl.isNotEmpty)
                      Container(
                        height: 200,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                widget.event.imageUrl,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: CircleAvatar(
                                backgroundColor:
                                    theme.colorScheme.surface.withOpacity(0.8),
                                child: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    // Image edit functionality
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Image editing coming soon'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Title field
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description field
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Location field
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Date and time section
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Date',
                                border: OutlineInputBorder(),
                              ),
                              child: Text(dateFormat.format(_startDate)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectTime(context),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Time',
                                border: OutlineInputBorder(),
                              ),
                              child: Text(timeFormat.format(_startDate)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Price and max attendees section
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            decoration: const InputDecoration(
                              labelText: 'Price',
                              border: OutlineInputBorder(),
                              prefixText: '\$',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _maxAttendeesController,
                            decoration: const InputDecoration(
                              labelText: 'Max Attendees',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Category field
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Is private toggle
                    SwitchListTile(
                      title: const Text('Private Event'),
                      subtitle:
                          const Text('Only invited guests can see this event'),
                      value: _isPrivate,
                      onChanged: (value) {
                        setState(() {
                          _isPrivate = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _saveEvent();
                            },
                            child: const Text('Save Changes'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Delete button
                    OutlinedButton.icon(
                      onPressed: () {
                        _showDeleteConfirmation();
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: theme.colorScheme.error,
                      ),
                      label: Text(
                        'Delete Event',
                        style: TextStyle(
                          color: theme.colorScheme.error,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.colorScheme.error),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _startDate.hour,
          _startDate.minute,
        );

        // Also update end time to be on the same day
        _endDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _endDate.hour,
          _endDate.minute,
        );
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startDate),
    );

    if (picked != null) {
      setState(() {
        _startDate = DateTime(
          _startDate.year,
          _startDate.month,
          _startDate.day,
          picked.hour,
          picked.minute,
        );

        // Set end time to be 2 hours after start time by default
        _endDate = _startDate.add(const Duration(hours: 2));
      });
    }
  }

  void _saveEvent() {
    try {
      final updatedEvent = Event(
        id: widget.event.id,
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl: widget.event.imageUrl,
        categories: _categories,
        location: _locationController.text,
        startDate: _startDate,
        endDate: _endDate,
        price: double.tryParse(_priceController.text) ?? 0.0,
        maxAttendees: int.tryParse(_maxAttendeesController.text) ?? 50,
        attendees: widget.event.attendees,
        latitude: widget.event.latitude,
        longitude: widget.event.longitude,
        isSaved: widget.event.isSaved,
        isVirtual: widget.event.isVirtual,
        isPrivate: _isPrivate,
        rating: widget.event.rating,
        reviewCount: widget.event.reviewCount,
        organizer: widget.event.organizer,
        tags: widget.event.tags,
        createdAt: widget.event.createdAt,
        updatedAt: DateTime.now(),
        url: widget.event.url,
        address: widget.event.address,
        contactInfo: widget.event.contactInfo,
        metadata: widget.event.metadata,
        category: widget.event.category,
        createdBy: widget.event.createdBy,
        venue: widget.event.venue,
      );

      context.read<EventBloc>().add(UpdateEvent(updatedEvent));

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event updated successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating event: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: const Text(
              'Are you sure you want to delete this event? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteEvent();
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent() {
    try {
      context.read<EventBloc>().add(DeleteEvent(widget.event.id));

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event deleted successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting event: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Map<String, dynamic> _eventToJson() {
    return {
      'id': widget.event.id,
      'title': _titleController.text,
      'description': _descriptionController.text,
      'imageUrl': widget.event.imageUrl,
      'location': _locationController.text,
      'startDate': _startDate.toIso8601String(),
      'endDate': _endDate.toIso8601String(),
      'price': double.tryParse(_priceController.text) ?? 0.0,
      'maxAttendees': int.tryParse(_maxAttendeesController.text) ?? 50,
      'attendees': widget.event.attendees,
      'latitude': widget.event.latitude,
      'longitude': widget.event.longitude,
      'isPrivate': _isPrivate,
      'rating': widget.event.rating,
      'reviewCount': widget.event.reviewCount,
      'categories': _categories,
      'organizer': widget.event.organizer,
      'tags': widget.event.tags,
      'isVirtual': widget.event.isVirtual,
      'createdAt': widget.event.createdAt?.toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'url': widget.event.url,
      'address': widget.event.address,
      'contactInfo': widget.event.contactInfo,
    };
  }
}

// Helper extension for Event to make it serializable
extension EventJson on Event {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'location': location,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'price': price,
      'maxAttendees': maxAttendees,
      'attendees': attendees,
      'latitude': latitude,
      'longitude': longitude,
      'isPrivate': isPrivate,
      'rating': rating,
      'reviewCount': reviewCount,
      'categories': categories,
      'organizer': organizer,
      'tags': tags,
      'isVirtual': isVirtual,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'url': url,
      'address': address,
      'contactInfo': contactInfo,
    };
  }
}
