import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../../../core/utils/mock_student_data.dart';
import '../../../core/utils/mock_class_data.dart';
import '../../../data/models/student.dart';
import '../../../data/models/tuition_class.dart';

class StudentsListScreen extends StatefulWidget {
  const StudentsListScreen({super.key});

  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  late List<Student> _students;
  late List<TuitionClass> _classes;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    debugPrint('StudentsListScreen: initializing data');
    _students = MockStudentData.getMockStudents();
    _classes = MockClassData.getMockClasses();
    debugPrint(
      'StudentsListScreen: loaded ${_students.length} students and ${_classes.length} classes',
    );
  }

  List<Student> get filteredStudents {
    if (_searchQuery.isEmpty) {
      return _students;
    }

    return _students.where((student) {
      final fullName = student.fullName.toLowerCase();
      final searchLower = _searchQuery.toLowerCase();
      return fullName.contains(searchLower);
    }).toList();
  }

  String getClassName(String classId) {
    final tuitionClass = _classes.firstWhere(
      (c) => c.id == classId,
      orElse: () => TuitionClass(
        id: '',
        name: 'Unknown Class',
        subject: '',
        description: '',
        monthlyFee: 0,
        teacherId: '',
        startDate: DateTime.now(),
        schedule: '',
        maxStudents: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    return tuitionClass.name;
  }

  String getClassNames(List<String> classIds) {
    if (classIds.isEmpty) {
      return 'Not enrolled';
    }

    final classNames = classIds.map((id) => getClassName(id)).toList();
    return classNames.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search students...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // Status counts
          Row(
            children: [
              _buildStatusCard(
                'Active Students',
                _students.where((s) => s.isActive).length.toString(),
                Colors.green,
              ),
              const SizedBox(width: 16),
              _buildStatusCard(
                'Inactive Students',
                _students.where((s) => !s.isActive).length.toString(),
                Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Table header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: const [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    'Class',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 40), // Space for the action button
              ],
            ),
          ),

          // Student list
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: filteredStudents.isEmpty
                  ? const Center(child: Text('No students found'))
                  : ListView.builder(
                      itemCount: filteredStudents.length,
                      itemBuilder: (context, index) {
                        final student = filteredStudents[index];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade300,
                                width: index < filteredStudents.length - 1
                                    ? 1
                                    : 0,
                              ),
                            ),
                          ),
                          child: ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    student.fullName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    getClassNames(student.classIds),
                                    style: TextStyle(
                                      color: student.classIds.isEmpty
                                          ? Colors.orange
                                          : null,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: student.isActive
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        student.isActive
                                            ? 'Active'
                                            : 'Inactive',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: student.isActive
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {
                                    // Show options for the student
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          _buildActionSheet(student),
                                    );
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              // Navigate to student details screen
                            },
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(child: Icon(Icons.people, color: color)),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSheet(Student student) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Student'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to edit student screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.class_),
            title: const Text('Manage Classes'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to manage classes screen
            },
          ),
          ListTile(
            leading: Icon(
              student.isActive ? Icons.block : Icons.check_circle,
              color: student.isActive ? Colors.red : Colors.green,
            ),
            title: Text(
              student.isActive ? 'Mark as Inactive' : 'Mark as Active',
            ),
            onTap: () {
              Navigator.pop(context);
              // Update student status
            },
          ),
        ],
      ),
    );
  }
}
