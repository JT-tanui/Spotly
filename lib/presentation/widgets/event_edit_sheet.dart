import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/event_category.dart';
import '../blocs/event_bloc/event_bloc.dart';
import '../blocs/event_bloc/event_event.dart';
import '../blocs/event_bloc/event_state.dart';

class EventEditSheet extends StatefulWidget {
  final Event event;

  const EventEditSheet({super.key, required this.event});

  @override
  State<EventEditSheet> createState() => _EventEditSheetState();
}

class _EventEditSheetState extends State<EventEditSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late DateTime _startTime;
  late DateTime _endTime;
  late List<EventCategory> _selectedCategories;
  double? _price;
  int? _maxAttendees;
  bool _isPrivate = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _addressController = TextEditingController(text: widget.event.address);
    _startTime = widget.event.startTime;
    _endTime = widget.event.endTime;
    _selectedCategories = List.from(widget.event.categories);
    _price = widget.event.price;
    _maxAttendees = widget.event.maxAttendees;
    _isPrivate = widget.event.isPrivate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_startTime),
      );

      if (pickedTime != null) {
        setState(() {
          _startTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _endTime,
      firstDate: _startTime,
      lastDate: _startTime.add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_endTime),
      );

      if (pickedTime != null) {
        setState(() {
          _endTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _updateEvent() {
    if (_formKey.currentState!.validate()) {
      final updatedEvent = Event(
        id: widget.event.id,
        title: _titleController.text,
        description: _descriptionController.text,
        startTime: _startTime,
        endTime: _endTime,
        latitude: widget.event.latitude,
        longitude: widget.event.longitude,
        address: _addressController.text,
        imageUrl: widget.event.imageUrl,
        createdBy: widget.event.createdBy,
        createdAt: widget.event.createdAt,
        categories: _selectedCategories,
        maxAttendees: _maxAttendees,
        price: _price,
        isPrivate: _isPrivate,
        contactInfo: widget.event.contactInfo,
      );

      context.read<EventBloc>().add(UpdateEventEvent(updatedEvent));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, y');
    final timeFormat = DateFormat('h:mm a');

    return BlocListener<EventBloc, EventState>(
      listener: (context, state) {
        if (state is EventError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is EventLoaded) {
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Edit Event',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Start Time'),
                  subtitle: Text(
                    '${dateFormat.format(_startTime)} at ${timeFormat.format(_startTime)}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectStartTime(context),
                ),
                ListTile(
                  title: const Text('End Time'),
                  subtitle: Text(
                    '${dateFormat.format(_endTime)} at ${timeFormat.format(_endTime)}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectEndTime(context),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // TODO: Add category selection
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Price (optional)',
                    border: OutlineInputBorder(),
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _price?.toString(),
                  onChanged: (value) {
                    _price = double.tryParse(value);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Max Attendees (optional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _maxAttendees?.toString(),
                  onChanged: (value) {
                    _maxAttendees = int.tryParse(value);
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Private Event'),
                  value: _isPrivate,
                  onChanged: (value) {
                    setState(() {
                      _isPrivate = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<EventBloc, EventState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is EventLoading ? null : _updateEvent,
                      child: state is EventLoading
                          ? const CircularProgressIndicator()
                          : const Text('Update Event'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
