import 'package:flutter/material.dart';
import '../../../core/utils/notification_utils.dart';
import '../../../data/models/tuition_class.dart';
import '../../../data/repositories/class_repository.dart';
import 'classes_list_screen.dart';

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
  bool _isActive = true;
  bool _isLoading = false;
  bool _isFormValid = false; // Track if required fields are valid

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
      _isActive = widget.tuitionClass!.isActive;
    }

    // Add listeners that respond to any text changes
    _nameController.addListener(_validateForm);
    _monthlyFeeController.addListener(_validateForm);

    // Initial validation
    _validateForm();
  }

  // Validate required fields
  void _validateForm() {
    final nameValid = _nameController.text.trim().isNotEmpty;
    final feeValid =
        _monthlyFeeController.text.trim().isNotEmpty &&
        double.tryParse(_monthlyFeeController.text.trim()) != null;

    // Only update state if the validity has changed
    if (_isFormValid != (nameValid && feeValid)) {
      setState(() {
        _isFormValid = nameValid && feeValid;
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers - this also removes any listeners
    _nameController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    _monthlyFeeController.dispose();
    _scheduleController.dispose();
    super.dispose();
  }

  Future<void> _saveClass() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final now = DateTime.now();

      if (widget.tuitionClass == null) {
        // Create new class using the repository with the direct endpoint
        await _classRepository.createClassDirect(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          monthlyFee: double.parse(_monthlyFeeController.text.trim()),
          paymentDueDay: 15, // Fixed value as per requirement
          subject: _subjectController.text.trim(),
          usualScheduledOn: _scheduleController.text.trim(),
        );

        if (mounted) {
          NotificationUtils.showSuccessNotification(
            context,
            'Class created successfully',
          );

          // Navigate to classes list screen instead of going back
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ClassesListScreen()),
          );
        }
      } else {
        // Update existing class - use the repository as before
        final tuitionClass = widget.tuitionClass!.copyWith(
          name: _nameController.text.trim(),
          subject: _subjectController.text.trim(),
          description: _descriptionController.text.trim(),
          monthlyFee: double.parse(_monthlyFeeController.text.trim()),
          schedule: _scheduleController.text.trim(),
          isActive: _isActive,
          updatedAt: now,
        );

        await _classRepository.updateClass(tuitionClass);

        if (mounted) {
          NotificationUtils.showSuccessNotification(
            context,
            'Class updated successfully',
          );
          Navigator.pop(context, true); // Return true to indicate success
        }
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
                    // Educational Icon/Image at the top
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 24.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.school,
                          size: 80,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    // Class title
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Text(
                          widget.tuitionClass == null
                              ? 'New Tuition Class'
                              : 'Edit Class Details',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Class Name *',
                        hintText: 'E.g., Advanced Mathematics Grade 10',
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.class_),
                        helperText: 'A clear, descriptive name for your class',
                      ),
                      onChanged: (value) {
                        _validateForm();
                      },
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
                      decoration: InputDecoration(
                        labelText: 'Subject (Optional)',
                        hintText: 'E.g., Mathematics, Physics, Chemistry',
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.subject),
                        helperText: 'The academic subject of this class',
                      ),
                      // Subject is optional
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description (Optional)',
                        hintText:
                            'E.g., This class covers advanced topics in algebra and calculus for grade 10 students...',
                        border: const OutlineInputBorder(),
                        helperText:
                            'A brief description of what students will learn',
                      ),
                      maxLines: 3,
                      // Description is optional
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _monthlyFeeController,
                      decoration: InputDecoration(
                        labelText: 'Monthly Fee *',
                        hintText: '2500',
                        border: const OutlineInputBorder(),
                        prefixText: '\$',
                        suffixIcon: const Icon(Icons.monetization_on),
                        helperText: 'Monthly fee amount (numbers only)',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _validateForm();
                      },
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
                    TextFormField(
                      controller: _scheduleController,
                      decoration: InputDecoration(
                        labelText: 'Schedule (Optional)',
                        hintText: 'Monday, Wednesday - 4:00 PM to 6:00 PM',
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.calendar_today),
                        helperText:
                            'Days and times when this class takes place',
                      ),
                      // Schedule is optional
                    ),
                    // Maximum Students field removed
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: SwitchListTile(
                        title: const Text(
                          'Class Status',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          _isActive
                              ? 'Active - Class is visible to students'
                              : 'Inactive - Class is hidden from students',
                          style: TextStyle(
                            color: _isActive
                                ? Colors.green[700]
                                : Colors.red[700],
                          ),
                        ),
                        secondary: Icon(
                          _isActive ? Icons.visibility : Icons.visibility_off,
                          color: _isActive
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                        value: _isActive,
                        onChanged: (bool value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    const SizedBox(height: 24),
                    // Action buttons with better styling
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            // Disable button if form is invalid
                            onPressed: _isFormValid ? _saveClass : null,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              backgroundColor: _isFormValid
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[400],
                              foregroundColor: Colors.white,
                              // Reduce opacity when disabled
                              disabledBackgroundColor: Colors.grey[400],
                              disabledForegroundColor: Colors.white70,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  widget.tuitionClass == null
                                      ? Icons.add_circle
                                      : Icons.save,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.tuitionClass == null
                                      ? 'Create Class'
                                      : 'Update Class',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
