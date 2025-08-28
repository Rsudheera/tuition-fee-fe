import 'package:flutter/material.dart';
import '../../../core/utils/notification_utils.dart';
import '../../../data/models/tuition_class.dart';
import '../../../data/repositories/class_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class ClassFormScreen extends StatefulWidget {
  final TuitionClass? tuitionClass;

  // If tuitionClass is null, we're creating a new class
  // If tuitionClass is not null, we're editing an existing class
  const ClassFormScreen({super.key, this.tuitionClass});

  @override
  State<ClassFormScreen> createState() => _ClassFormScreenState();
}

class _ClassFormScreenState extends State<ClassFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ClassRepository _classRepository = ClassRepository();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _monthlyFeeController = TextEditingController();
  final TextEditingController _scheduleController = TextEditingController();
  final TextEditingController _maxStudentsController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.tuitionClass != null) {
      // Editing mode - populate form with existing data
      _nameController.text = widget.tuitionClass!.name;
      _subjectController.text = widget.tuitionClass!.subject;
      _descriptionController.text = widget.tuitionClass!.description;
      _monthlyFeeController.text = widget.tuitionClass!.monthlyFee.toString();
      _scheduleController.text = widget.tuitionClass!.schedule;
      _maxStudentsController.text = widget.tuitionClass!.maxStudents.toString();
      _startDate = widget.tuitionClass!.startDate;
      _endDate = widget.tuitionClass!.endDate;
      _isActive = widget.tuitionClass!.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    _monthlyFeeController.dispose();
    _scheduleController.dispose();
    _maxStudentsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : (_endDate ?? DateTime.now()),
      firstDate: isStartDate ? DateTime.now() : _startDate,
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _saveClass() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final now = DateTime.now();

      final tuitionClass = widget.tuitionClass == null
          ? TuitionClass(
              id: const Uuid().v4(),
              name: _nameController.text.trim(),
              subject: _subjectController.text.trim(),
              description: _descriptionController.text.trim(),
              monthlyFee: double.parse(_monthlyFeeController.text.trim()),
              teacherId:
                  'current_teacher_id', // You might want to get this from a provider
              startDate: _startDate,
              endDate: _endDate,
              schedule: _scheduleController.text.trim(),
              maxStudents: int.parse(_maxStudentsController.text.trim()),
              currentStudents: 0,
              isActive: _isActive,
              createdAt: now,
              updatedAt: now,
            )
          : widget.tuitionClass!.copyWith(
              name: _nameController.text.trim(),
              subject: _subjectController.text.trim(),
              description: _descriptionController.text.trim(),
              monthlyFee: double.parse(_monthlyFeeController.text.trim()),
              startDate: _startDate,
              endDate: _endDate,
              schedule: _scheduleController.text.trim(),
              maxStudents: int.parse(_maxStudentsController.text.trim()),
              isActive: _isActive,
              updatedAt: now,
            );

      if (widget.tuitionClass == null) {
        // Create new class
        await _classRepository.createClass(tuitionClass);
        if (mounted) {
          NotificationUtils.showSuccessNotification(
            context,
            'Class created successfully',
          );
        }
      } else {
        // Update existing class
        await _classRepository.updateClass(tuitionClass);
        if (mounted) {
          NotificationUtils.showSuccessNotification(
            context,
            'Class updated successfully',
          );
        }
      }

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        NotificationUtils.showErrorNotification(
          context,
          'Error: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.tuitionClass == null ? 'Create New Class' : 'Edit Class',
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Class Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a class name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a subject';
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
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _monthlyFeeController,
                      decoration: const InputDecoration(
                        labelText: 'Monthly Fee',
                        border: OutlineInputBorder(),
                        prefixText: '\$',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the monthly fee';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _selectDate(context, true),
                      child: AbsorbPointer(
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Start Date',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            DateFormat('yyyy-MM-dd').format(_startDate),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _selectDate(context, false),
                      child: AbsorbPointer(
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'End Date (Optional)',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _endDate != null
                                ? DateFormat('yyyy-MM-dd').format(_endDate!)
                                : 'Not set',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _scheduleController,
                      decoration: const InputDecoration(
                        labelText:
                            'Schedule (e.g., Monday, Wednesday - 4:00 PM)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a schedule';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _maxStudentsController,
                      decoration: const InputDecoration(
                        labelText: 'Maximum Students',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the maximum number of students';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Active'),
                      subtitle: const Text(
                        'Inactive classes won\'t be visible to students',
                      ),
                      value: _isActive,
                      onChanged: (bool value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _saveClass,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: Text(
                        widget.tuitionClass == null
                            ? 'Create Class'
                            : 'Update Class',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
