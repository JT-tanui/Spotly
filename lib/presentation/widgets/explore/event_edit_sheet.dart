import 'package:flutter/material.dart';
import 'package:spotly/domain/entities/event.dart';

class EventEditSheet extends StatefulWidget {
  final Event? event;
  final Function(Event) onSave;

  const EventEditSheet({
    super.key,
    this.event,
    required this.onSave,
  });

  @override
  State<EventEditSheet> createState() => _EventEditSheetState();
}

class _EventEditSheetState extends State<EventEditSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _imageUrlController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _maxAttendeesController;
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title);
    _descriptionController =
        TextEditingController(text: widget.event?.description);
    _locationController = TextEditingController(text: widget.event?.location);
    _imageUrlController = TextEditingController(text: widget.event?.imageUrl);
    _categoryController =
        TextEditingController(text: widget.event?.categories.firstOrNull);
    _priceController = TextEditingController(
      text: widget.event?.price.toString() ?? '0.0',
    );
    _maxAttendeesController = TextEditingController(
      text: widget.event?.maxAttendees.toString() ?? '0',
    );
    _startDate = widget.event?.startDate;
    _endDate = widget.event?.endDate;
    _categories = widget.event?.categories ?? [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _maxAttendeesController.dispose();
    super.dispose();
  }

  void _selectDateTime(bool isStart) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate:
          isStart ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          if (isStart) {
            _startDate = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
          } else {
            _endDate = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
          }
        });
      }
    }
  }

  void _saveEvent() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select start and end time'),
          ),
        );
        return;
      }

      if (_categoryController.text.isNotEmpty) {
        _categories = [_categoryController.text];
      }

      final event = Event(
        id: widget.event?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        location: _locationController.text,
        startDate: _startDate!,
        endDate: _endDate!,
        imageUrl: _imageUrlController.text,
        categories: _categories,
        price: double.parse(_priceController.text),
        maxAttendees: int.parse(_maxAttendeesController.text),
        attendees: widget.event?.attendees ?? 0,
        latitude: widget.event?.latitude ?? 0.0,
        longitude: widget.event?.longitude ?? 0.0,
        organizer: widget.event?.organizer ?? 'Temporary',
        rating: widget.event?.rating ?? 0.0,
        reviewCount: widget.event?.reviewCount ?? 0,
        tags: widget.event?.tags ?? [],
        isPrivate: widget.event?.isPrivate ?? false,
      );

      widget.onSave(event);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.event == null ? 'Create Event' : 'Edit Event',
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
                    if (value?.isEmpty ?? true) {
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
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter an image URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value!) == null) {
                            return 'Please enter a valid price';
                          }
                          return null;
                        },
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
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter max attendees';
                          }
                          if (int.tryParse(value!) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _selectDateTime(true),
                        child: Text(
                          _startDate == null
                              ? 'Select Start Time'
                              : 'Start: ${_startDate!.day}/${_startDate!.month}/${_startDate!.year} ${_startDate!.hour}:${_startDate!.minute.toString().padLeft(2, '0')}',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _selectDateTime(false),
                        child: Text(
                          _endDate == null
                              ? 'Select End Time'
                              : 'End: ${_endDate!.day}/${_endDate!.month}/${_endDate!.year} ${_endDate!.hour}:${_endDate!.minute.toString().padLeft(2, '0')}',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveEvent,
                  child: Text(
                    widget.event == null ? 'Create Event' : 'Save Changes',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
