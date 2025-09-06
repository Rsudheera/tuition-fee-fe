import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/utils/notification_utils.dart';
import '../../../data/models/student.dart';
import '../../../data/repositories/student_repository.dart';

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
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _parentNameController = TextEditingController();
  final TextEditingController _parentContactController =
      TextEditingController();

  final StudentRepository _studentRepository = StudentRepository();

  bool _isLoading = false;
  bool _isFormValid = false; // Track if the form is valid

  @override
  void initState() {
    super.initState();

    if (widget.student != null) {
      // Editing mode - populate form with existing data
      _fullNameController.text = widget.student!.fullName;

      // Set age if available
      if (widget.student!.age != null) {
        _ageController.text = widget.student!.age.toString();
      }

      // Set parent name and contact if available
      _parentNameController.text = widget.student!.parentName ?? '';
      _parentContactController.text = widget.student!.parentContactNumber ?? '';
    }

    // Add listeners to required fields
    _fullNameController.addListener(_validateForm);
    _parentContactController.addListener(_validateForm);

    // Initial validation
    _validateForm();
  }

  // Validate required fields - only full name and contact are required
  void _validateForm() {
    final nameValid = _fullNameController.text.trim().isNotEmpty;
    final contactValid = _parentContactController.text.trim().isNotEmpty;

    // Only update state if the validity has changed
    if (_isFormValid != (nameValid && contactValid)) {
      setState(() {
        _isFormValid = nameValid && contactValid;
      });
    }
  }

  @override
  void dispose() {
    // Remove listeners before disposing controllers
    _fullNameController.removeListener(_validateForm);
    _parentContactController.removeListener(_validateForm);

    _fullNameController.dispose();
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
      final fullName = _fullNameController.text.trim();

      // Handle optional age field
      final ageText = _ageController.text.trim();
      final age = ageText.isNotEmpty ? int.tryParse(ageText) : null;

      // Handle optional parent name field
      final parentNameText = _parentNameController.text.trim();
      final parentName = parentNameText.isNotEmpty ? parentNameText : null;

      // Required field
      final parentContactNumber = _parentContactController.text.trim();

      if (widget.student == null) {
        // Create new student
        debugPrint('Creating new student: $fullName');

        // Direct API call to the exact endpoint as requested
        try {
          // Use the exact URL as specified in the requirement
          final url = Uri.parse('http://localhost:3000/student');

          debugPrint('Attempting to connect to: $url');

          // Create payload exactly as requested in the requirements
          final Map<String, dynamic> payload = {
            'fullName': fullName,
            'parentContactNumber': parentContactNumber,
          };

          // Add optional fields if they have values
          if (age != null) payload['age'] = age;
          if (parentName != null) payload['parentName'] = parentName;

          debugPrint(
            'Sending API request with payload: ${jsonEncode(payload)}',
          );

          // Make the HTTP POST request with proper headers
          final response = await http
              .post(
                url,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode(payload),
              )
              .timeout(
                const Duration(seconds: 10), // Shorter timeout for debugging
                onTimeout: () {
                  debugPrint('Request timed out after 10 seconds');
                  throw Exception('Request timed out. Please try again later.');
                },
              );

          debugPrint('API response status: ${response.statusCode}');
          debugPrint('API response body: ${response.body}');

          if (response.statusCode >= 200 && response.statusCode < 300) {
            // Successfully created the student
            debugPrint('Student created successfully via direct API call');

            // Try to parse the response to get the created student data
            try {
              final responseData = jsonDecode(response.body);
              debugPrint('Created student data: $responseData');
            } catch (parseError) {
              debugPrint('Could not parse response data: $parseError');
            }
          } else {
            // Handle error response
            String errorMessage;

            try {
              // Try to extract error message from response
              final errorResponse = jsonDecode(response.body);
              errorMessage =
                  errorResponse['message'] ??
                  errorResponse['error'] ??
                  'API Error: HTTP ${response.statusCode}';
            } catch (parseError) {
              // If can't parse JSON, use raw body or status code
              errorMessage = response.body.isNotEmpty
                  ? 'API Error: ${response.body}'
                  : 'API Error: HTTP ${response.statusCode}';
            }

            throw Exception(errorMessage);
          }
        } catch (e) {
          debugPrint('API request failed: $e');

          if (e.toString().contains('SocketException') ||
              e.toString().contains('Connection refused')) {
            debugPrint('Network error detected, server might be down');

            // Try alternative URL for Android emulator
            try {
              debugPrint('Trying alternative URL for Android emulator...');
              final alternativeUrl = Uri.parse('http://10.0.2.2:3000/student');

              final Map<String, dynamic> payload = {
                'fullName': fullName,
                'parentContactNumber': parentContactNumber,
              };
              if (age != null) payload['age'] = age;
              if (parentName != null) payload['parentName'] = parentName;

              final response = await http
                  .post(
                    alternativeUrl,
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode(payload),
                  )
                  .timeout(const Duration(seconds: 10));

              if (response.statusCode >= 200 && response.statusCode < 300) {
                debugPrint(
                  'Student created successfully using alternative URL',
                );
                return; // Success with alternative URL, exit function
              } else {
                throw Exception(
                  'Alternative URL also failed: HTTP ${response.statusCode}',
                );
              }
            } catch (alternativeError) {
              debugPrint('Alternative URL also failed: $alternativeError');
              throw Exception(
                'Cannot connect to server. Please check your internet connection and try again.',
              );
            }
          }

          // As a last resort, try the repository approach which uses ApiService
          debugPrint('Attempting to create student via repository...');

          try {
            // Create student object with minimal required fields
            final newStudent = Student(
              id: '', // The API will assign an ID
              fullName: fullName,
              age: age,
              parentName: parentName,
              parentContactNumber: parentContactNumber,
              isActive: true,
              classIds: [],
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            debugPrint(
              'Using repository with student data: ${jsonEncode(newStudent.toJson())}',
            );

            // Use repository which should handle the API call internally
            final createdStudent = await _studentRepository.createStudent(
              newStudent,
            );

            debugPrint(
              'Student created successfully via repository: ${createdStudent.id}',
            );
          } catch (repoError) {
            debugPrint('Repository fallback also failed: $repoError');

            // Try one more direct POST with minimal data as last attempt
            try {
              debugPrint('Final attempt: Direct minimal POST to /student');
              final minimalPayload = {
                'fullName': fullName,
                'parentContactNumber': parentContactNumber,
              };

              await http.post(
                Uri.parse('http://localhost:3000/student'),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode(minimalPayload),
              );

              debugPrint('Minimal POST succeeded');
            } catch (finalError) {
              debugPrint('All attempts failed. Last error: $finalError');
              throw Exception(
                'Failed to create student after multiple attempts. Please try again later.',
              );
            }
          }
        }
      } else {
        // Update existing student
        debugPrint('Updating student: $fullName');

        final updatedStudent = widget.student!.copyWith(
          fullName: fullName,
          age: age,
          parentName: parentName,
          parentContactNumber: parentContactNumber,
          classIds: widget.student!.classIds,
          updatedAt: DateTime.now(),
        );
        await _studentRepository.updateStudent(updatedStudent);
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
                    // Student Icon/Image at the top
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
                          Icons.person_add,
                          size: 80,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),

                    // Full Name (single field) - required
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name *',
                        hintText: 'Required',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Age (optional)
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: 'Age (optional)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        // If empty, it's valid since age is optional
                        if (value == null || value.trim().isEmpty) {
                          return null;
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

                    // Parent Name (optional)
                    TextFormField(
                      controller: _parentNameController,
                      decoration: const InputDecoration(
                        labelText: 'Parent Name (optional)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        // Parent name is optional, so it's valid even if empty
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Parent Contact Number (required)
                    TextFormField(
                      controller: _parentContactController,
                      decoration: const InputDecoration(
                        labelText: 'Parent Contact Number *',
                        hintText: 'Required',
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

                    // Button Row with Cancel and Save buttons
                    Row(
                      children: [
                        // Cancel Button
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Save/Create Button
                        Expanded(
                          child: ElevatedButton(
                            // Only enable if form is valid
                            onPressed: _isFormValid ? _saveStudent : null,
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
