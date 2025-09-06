import 'package:flutter/material.dart';
import '../../../data/models/tuition_class.dart';
import '../../../data/models/student.dart';
import '../../../data/repositories/class_repository.dart';
import '../../../data/repositories/student_repository.dart';

class AssignStudentsScreen extends StatefulWidget {
  const AssignStudentsScreen({Key? key}) : super(key: key);

  @override
  State<AssignStudentsScreen> createState() => _AssignStudentsScreenState();
}

class _AssignStudentsScreenState extends State<AssignStudentsScreen> {
  final ClassRepository _classRepository = ClassRepository();
  final StudentRepository _studentRepository = StudentRepository();

  bool _isLoading = true;
  List<TuitionClass> _classes = [];
  List<Student> _allStudents = [];
  Map<String, bool> _expandedClasses = {};
  Map<String, List<String>> _selectedStudents = {};
  Map<String, List<Student>> _assignedStudents = {};
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Load classes and students in parallel
      final classesResult = await _classRepository.getClasses();
      final studentsResult = await _studentRepository.getStudents();

      // Initialize expanded states and selected students
      final expandedMap = <String, bool>{};
      final selectedStudentsMap = <String, List<String>>{};
      final assignedStudentsMap = <String, List<Student>>{};

      for (var cls in classesResult) {
        expandedMap[cls.id] = false;
        selectedStudentsMap[cls.id] = [];
        assignedStudentsMap[cls.id] = [];

        // Filter students assigned to this class
        assignedStudentsMap[cls.id] = studentsResult
            .where((student) => student.classIds.contains(cls.id))
            .toList();
      }

      if (mounted) {
        setState(() {
          _classes = classesResult;
          _allStudents = studentsResult;
          _expandedClasses = expandedMap;
          _selectedStudents = selectedStudentsMap;
          _assignedStudents = assignedStudentsMap;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load data: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _assignStudentsToClass(String classId) async {
    if (_selectedStudents[classId]?.isEmpty ?? true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No students selected'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      for (String studentId in _selectedStudents[classId]!) {
        try {
          await _studentRepository.assignStudentToClass(studentId, classId);
        } catch (e) {
          print('Error assigning student $studentId to class $classId: $e');
          // Continue with the next student even if one fails
        }
      }

      // Clear selection and reload data
      _selectedStudents[classId] = [];
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Students assigned successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error assigning students: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _removeStudentFromClass(String studentId, String classId) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Use repository method to remove the student from the class
      await _studentRepository.removeStudentFromClass(studentId, classId);

      // Reload data
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Student removed from class'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing student: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Class Enrollments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadData, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_classes.isEmpty) {
      return const Center(
        child: Text('No classes found', style: TextStyle(fontSize: 18)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      itemCount: _classes.length + 1, // +1 for the header
      itemBuilder: (context, index) {
        // Header widget with icon and instructions
        if (index == 0) {
          return Card(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.people_alt,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Manage Class Enrollments',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tap on a class to expand it and manage enrolled students. You can add new students or remove existing ones.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.amber),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Students can be enrolled in multiple classes. Use the dropdown to select students to add.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Adjust index for class list (subtract 1 for the header)
        final classIndex = index - 1;
        final tuitionClass = _classes[classIndex];
        final isExpanded = _expandedClasses[tuitionClass.id] ?? false;
        final assignedStudents = _assignedStudents[tuitionClass.id] ?? [];

        // Filter out students already assigned to this class
        final availableStudents = _allStudents
            .where((student) => !student.classIds.contains(tuitionClass.id))
            .toList();

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              // Class header with expand/collapse button
              ListTile(
                title: Text(
                  tuitionClass.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  tuitionClass.subject ?? 'No subject',
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${assignedStudents.length} students'),
                    const SizedBox(width: 16),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    _expandedClasses[tuitionClass.id] = !isExpanded;
                  });
                },
              ),
              // Expanded content
              if (isExpanded) ...[
                const Divider(),
                // Already assigned students section
                if (assignedStudents.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Assigned Students (${assignedStudents.length})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: assignedStudents.length,
                    itemBuilder: (context, studentIndex) {
                      final student = assignedStudents[studentIndex];
                      return ListTile(
                        title: Text(student.fullName),
                        subtitle: Text(student.school ?? 'No school'),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => _removeStudentFromClass(
                            student.id,
                            tuitionClass.id,
                          ),
                          tooltip: 'Remove from class',
                        ),
                      );
                    },
                  ),
                  const Divider(),
                ],
                // Section to add new students
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Add Students (${availableStudents.length} available)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Student selection dropdown and list
                if (availableStudents.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No more students available to add'),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Multi-select dropdown for students
                        DropdownButton<String>(
                          hint: const Text('Select students to add'),
                          isExpanded: true,
                          items: availableStudents.map((student) {
                            return DropdownMenuItem<String>(
                              value: student.id,
                              child: Text(student.fullName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                if (!_selectedStudents[tuitionClass.id]!
                                    .contains(value)) {
                                  _selectedStudents[tuitionClass.id]!.add(
                                    value,
                                  );
                                }
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        // Display selected students to add
                        if (_selectedStudents[tuitionClass.id]!.isNotEmpty) ...[
                          const Text(
                            'Students to add:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...(_selectedStudents[tuitionClass.id]!.map((
                            studentId,
                          ) {
                            final student = _allStudents.firstWhere(
                              (s) => s.id == studentId,
                            );
                            return Chip(
                              label: Text(student.fullName),
                              deleteIcon: const Icon(Icons.cancel),
                              onDeleted: () {
                                setState(() {
                                  _selectedStudents[tuitionClass.id]!.remove(
                                    studentId,
                                  );
                                });
                              },
                            );
                          }).toList()),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                _assignStudentsToClass(tuitionClass.id),
                            child: const Text('Assign Selected Students'),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}
