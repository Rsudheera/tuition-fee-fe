import 'package:flutter/material.dart';
import '../../../data/models/student.dart';
import '../../../data/models/tuition_class.dart';
import '../../../data/repositories/student_repository.dart';
import '../../../data/repositories/class_repository.dart';
import 'student_form_screen.dart';

class StudentsListScreen extends StatefulWidget {
  const StudentsListScreen({super.key});

  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  late List<Student> _students = [];
  late List<TuitionClass> _classes = [];
  String _searchQuery = '';
  bool _isLoading = true;
  String? _errorMessage;

  // Create instances of our repositories
  final StudentRepository _studentRepository = StudentRepository();
  final ClassRepository _classRepository = ClassRepository();

  @override
  void initState() {
    super.initState();
    debugPrint('StudentsListScreen: initializing data');
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load data in parallel
      final studentsResult = await _studentRepository.getStudents();
      final classesResult = await _classRepository.getClasses();

      setState(() {
        _students = studentsResult;
        _classes = classesResult;
        _isLoading = false;
      });

      debugPrint(
        'StudentsListScreen: loaded ${_students.length} students and ${_classes.length} classes',
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: ${e.toString()}';
        _isLoading = false;
      });
      debugPrint('Error loading data: $e');
    }
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
        paymentDueDay: null, // Made null
        usualScheduledOn: '',
        status: false,
        teacherId: '',
        startDate: DateTime.now(),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StudentFormScreen()),
          ).then((value) {
            if (value == true) {
              // Refresh the student list if a new student was added
              _loadData();
            }
          });
        },
        tooltip: 'Add New Student',
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : Padding(
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: const Row(
                      children: [
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
                                        width:
                                            index < filteredStudents.length - 1
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: student.isActive
                                                    ? Colors.green.withOpacity(
                                                        0.1,
                                                      )
                                                    : Colors.red.withOpacity(
                                                        0.1,
                                                      ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
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
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(child: Icon(Icons.people, color: color, size: 20)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentFormScreen(student: student),
                ),
              ).then((value) {
                if (value == true) {
                  // Refresh the student list if the student was updated
                  _loadData();
                }
              });
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
            onTap: () async {
              Navigator.pop(context);
              // Update student status
              try {
                final bool success = await _studentRepository
                    .toggleStudentStatus(student.id, !student.isActive);
                if (success) {
                  _loadData(); // Refresh data after status change
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        student.isActive
                            ? 'Student marked as inactive'
                            : 'Student marked as active',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update status: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
