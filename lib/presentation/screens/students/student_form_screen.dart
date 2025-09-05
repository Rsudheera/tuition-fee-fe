import 'package:flutter/material.dart';
import '../../../core/utils/notification_utils.dart';
import '../../../data/models/student.dart';
import '../../../core/utils/mock_class_data.dart';
import '../../../data/models/tuition_class.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;

  // If student is null, we're creating a new student
  // If student is not null, we're editing an existing student
  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _parentNameController = TextEditingController();
  final TextEditingController _parentContactController =
      TextEditingController();

  String? _selectedClassId;
  List<TuitionClass> _classes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadClasses();

    if (widget.student != null) {
      // Editing mode - populate form with existing data
      // Split the fullName into firstName and lastName
      final nameParts = widget.student!.fullName.split(' ');
      _firstNameController.text = nameParts.isNotEmpty ? nameParts[0] : '';
      _lastNameController.text = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';

      // Set age if available
      if (widget.student!.age != null) {
        _ageController.text = widget.student!.age.toString();
      }

      // Set parent name and contact if available
      _parentNameController.text = widget.student!.parentName ?? '';
      _parentContactController.text = widget.student!.parentContactNumber ?? '';

      if (widget.student!.classIds.isNotEmpty) {
        _selectedClassId = widget.student!.classIds.first;
      }
    }
  }

  void _loadClasses() {
    // In a real app, you would load this from a repository
    setState(() {
      _classes = MockClassData.getMockClasses();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _parentNameController.dispose();
    _parentContactController.dispose();
    super.dispose();
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Construct the fullName from firstName and lastName
      final fullName =
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';
      // Get age as integer
      final age = int.tryParse(_ageController.text.trim());

      // Prepare classIds list
      final classIds = <String>[];
      if (_selectedClassId != null && _selectedClassId!.isNotEmpty) {
        classIds.add(_selectedClassId!);
      }

      if (widget.student == null) {
        // Create new student
        debugPrint('Creating new student: $fullName');
        debugPrint('Class selected: ${_selectedClassId ?? "None"}');
        debugPrint('Age: $age');
        debugPrint('Parent Name: ${_parentNameController.text}');
        debugPrint('Parent Contact: ${_parentContactController.text}');

        // In a real app, you would call the repository to create the student
        // final newStudent = Student(
        //   id: '',  // The API will assign an ID
        //   fullName: fullName,
        //   age: age,
        //   parentName: _parentNameController.text.trim(),
        //   parentContactNumber: _parentContactController.text.trim(),
        //   isActive: true,
        //   classIds: classIds,
        //   createdAt: DateTime.now(),
        //   updatedAt: DateTime.now(),
        // );
        // await _studentRepository.createStudent(newStudent);
      } else {
        // Update existing student
        debugPrint('Updating student: $fullName');
        debugPrint('Class selected: ${_selectedClassId ?? "None"}');
        debugPrint('Parent Contact: ${_parentContactController.text}');

        // In a real app, you would call the repository to update the student
        // final updatedStudent = widget.student!.copyWith(
        //   fullName: fullName,
        //   age: age,
        //   parentName: _parentNameController.text.trim(),
        //   parentContactNumber: _parentContactController.text.trim(),
        //   classIds: classIds,
        //   updatedAt: DateTime.now(),
        // );
        // await _studentRepository.updateStudent(updatedStudent);
      }

      // In a real app, you would save this to a repository
      // await _studentRepository.saveStudent(student);

      // For demo purposes, we'll just show a success message
      if (mounted) {
        NotificationUtils.showSuccessNotification(
          context,
          widget.student == null
              ? 'Student created successfully'
              : 'Student updated successfully',
        );
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
          widget.student == null ? 'Add New Student' : 'Edit Student',
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
                    // Full Name (First + Last Name)
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              labelText: 'First Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter first name';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              labelText: 'Last Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter last name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Age
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter age';
                        }
                        try {
                          final age = int.parse(value);
                          if (age <= 0) {
                            return 'Age must be positive';
                          }
                        } catch (e) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Class selection dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Class',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedClassId,
                      items: _classes.map((TuitionClass tuitionClass) {
                        return DropdownMenuItem<String>(
                          value: tuitionClass.id,
                          child: Text(tuitionClass.name),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedClassId = newValue;
                        });
                      },
                      validator: (value) {
                        // Optional: Make class selection required
                        // return value == null ? 'Please select a class' : null;
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Parent Name
                    TextFormField(
                      controller: _parentNameController,
                      decoration: const InputDecoration(
                        labelText: 'Parent Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter parent name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Parent Contact Number
                    TextFormField(
                      controller: _parentContactController,
                      decoration: const InputDecoration(
                        labelText: 'Parent Contact Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter parent contact number';
                        }
                        // You could add phone number validation here
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Save Button
                    ElevatedButton(
                      onPressed: _saveStudent,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        widget.student == null
                            ? 'Create Student'
                            : 'Update Student',
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
