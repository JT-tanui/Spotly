import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/event_category.dart';
import '../../blocs/event_bloc/event_bloc.dart';
import '../../blocs/event_bloc/event_event.dart';
import '../../blocs/event_bloc/event_state.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/category_selector.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _titleController;
  TextEditingController? _descriptionController;
  TextEditingController? _locationController;
  TextEditingController? _imageUrlController;
  TextEditingController? _priceController;
  TextEditingController? _capacityController;
  DateTime? _startTime;
  DateTime? _endTime;
  String? _imageUrl;
  List<EventCategory> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _imageUrlController = TextEditingController();
    _priceController = TextEditingController();
    _capacityController = TextEditingController();
    _selectedCategories = [EventCategory.predefinedCategories.first];
  }

  @override
  void dispose() {
    _titleController?.dispose();
    _descriptionController?.dispose();
    _locationController?.dispose();
    _imageUrlController?.dispose();
    _priceController?.dispose();
    _capacityController?.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_startTime == null || _endTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select both start and end times'),
          ),
        );
        return;
      }

      if (_endTime!.isBefore(_startTime!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End time must be after start time'),
          ),
        );
        return;
      }

      final event = CreateEvent(
        title: _titleController!.text,
        description: _descriptionController!.text,
        location: _locationController!.text,
        startTime: _startTime!,
        endTime: _endTime!,
        imageUrl: _imageUrlController!.text,
        categories: _selectedCategories.map((c) => c.name).toList(),
        price: double.parse(_priceController!.text),
        capacity: int.parse(_capacityController!.text),
      );
      context.read<EventBloc>().add(event);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter event title',
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
                hintText: 'Enter event description',
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
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'Enter event location',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
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
                hintText: 'Enter event image URL',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an image URL';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                hintText: 'Enter event price',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid price';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _capacityController,
              decoration: const InputDecoration(
                labelText: 'Capacity',
                hintText: 'Enter event capacity',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a capacity';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid capacity';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Category selector
            CategorySelector(
              initialValue: _selectedCategories,
              onCategoriesSelected: (categories) {
                setState(() {
                  _selectedCategories = categories;
                });
              },
            ),
            const SizedBox(height: 16),
            // Date and time pickers
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startTime ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _startTime = date;
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_startTime == null
                        ? 'Select Start Date'
                        : '${_startTime!.day}/${_startTime!.month}/${_startTime!.year}'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null && _startTime != null) {
                        setState(() {
                          _startTime = DateTime(
                            _startTime!.year,
                            _startTime!.month,
                            _startTime!.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    },
                    icon: const Icon(Icons.access_time),
                    label: Text(_startTime == null
                        ? 'Select Start Time'
                        : '${_startTime!.hour}:${_startTime!.minute.toString().padLeft(2, '0')}'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _endTime ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _endTime = date;
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_endTime == null
                        ? 'Select End Date'
                        : '${_endTime!.day}/${_endTime!.month}/${_endTime!.year}'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null && _endTime != null) {
                        setState(() {
                          _endTime = DateTime(
                            _endTime!.year,
                            _endTime!.month,
                            _endTime!.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    },
                    icon: const Icon(Icons.access_time),
                    label: Text(_endTime == null
                        ? 'Select End Time'
                        : '${_endTime!.hour}:${_endTime!.minute.toString().padLeft(2, '0')}'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Create Event',
              onPressed: _submitForm,
            ),
          ],
        ),
      ),
    );
  }
}
