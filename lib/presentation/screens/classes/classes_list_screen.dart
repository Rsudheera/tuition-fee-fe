import 'package:flutter/material.dart';
import '../../../core/utils/mock_class_data.dart';
import '../../../data/models/tuition_class.dart';
import '../../../data/repositories/class_repository.dart';
import '../../widgets/classes/class_card.dart';

class ClassesListScreen extends StatefulWidget {
  const ClassesListScreen({super.key});

  @override
  State<ClassesListScreen> createState() => _ClassesListScreenState();
}

class _ClassesListScreenState extends State<ClassesListScreen> {
  final ClassRepository _classRepository = ClassRepository();
  bool _isLoading = true;
  List<TuitionClass> _classes = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchClasses();
  }

  Future<void> _fetchClasses() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Try to get data from API first
      try {
        final classes = await _classRepository.getClasses();
        setState(() {
          _classes = classes;
          _isLoading = false;
        });
      } catch (apiError) {
        // If API fails, use mock data
        debugPrint('API error: $apiError, using mock data instead');
        final mockClasses = MockClassData.getMockClasses();
        setState(() {
          _classes = mockClasses;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load classes: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            ElevatedButton(
              onPressed: _fetchClasses,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_classes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No classes found', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to create class screen
              },
              child: const Text('Create New Class'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchClasses,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.7, // Adjusted to give more height to each card
          ),
          itemCount: _classes.length,
          itemBuilder: (context, index) {
            final tuitionClass = _classes[index];
            return ClassCard(
              tuitionClass: tuitionClass,
              onTap: () {
                // TODO: Navigate to class detail screen
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ClassDetailScreen(
                //       classId: tuitionClass.id,
                //     ),
                //   ),
                // );
              },
            );
          },
        ),
      ),
    );
  }
}
