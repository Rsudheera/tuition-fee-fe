import 'package:flutter/material.dart';

class StudentPerformanceScreen extends StatefulWidget {
  const StudentPerformanceScreen({super.key});

  @override
  State<StudentPerformanceScreen> createState() =>
      _StudentPerformanceScreenState();
}

class _StudentPerformanceScreenState extends State<StudentPerformanceScreen> {
  final List<Map<String, dynamic>> _dummyPerformanceData = [
    {
      'studentName': 'Amal Perera',
      'className': 'Physics Grade 12',
      'tests': [
        {'name': 'Mid Term', 'score': 85, 'maxScore': 100},
        {'name': 'Assignment 1', 'score': 78, 'maxScore': 100},
        {'name': 'Quiz 1', 'score': 90, 'maxScore': 100},
      ],
      'averageScore': 84.3,
    },
    {
      'studentName': 'Nimali Silva',
      'className': 'Chemistry Grade 11',
      'tests': [
        {'name': 'Mid Term', 'score': 92, 'maxScore': 100},
        {'name': 'Assignment 1', 'score': 88, 'maxScore': 100},
        {'name': 'Quiz 1', 'score': 95, 'maxScore': 100},
      ],
      'averageScore': 91.7,
    },
    {
      'studentName': 'Kasun Fernando',
      'className': 'Mathematics Grade 10',
      'tests': [
        {'name': 'Mid Term', 'score': 75, 'maxScore': 100},
        {'name': 'Assignment 1', 'score': 80, 'maxScore': 100},
        {'name': 'Quiz 1', 'score': 82, 'maxScore': 100},
      ],
      'averageScore': 79.0,
    },
    {
      'studentName': 'Dilini Jayawardena',
      'className': 'Biology Grade 12',
      'tests': [
        {'name': 'Mid Term', 'score': 88, 'maxScore': 100},
        {'name': 'Assignment 1', 'score': 92, 'maxScore': 100},
        {'name': 'Quiz 1', 'score': 86, 'maxScore': 100},
      ],
      'averageScore': 88.7,
    },
  ];

  String _selectedClass = 'All Classes';
  final List<String> _classOptions = [
    'All Classes',
    'Physics Grade 12',
    'Chemistry Grade 11',
    'Mathematics Grade 10',
    'Biology Grade 12',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Performance'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              // Show performance analytics
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Performance analytics coming soon'),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search students',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // Search functionality will be implemented later
                    },
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedClass,
                  items: _classOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedClass = newValue;
                      });
                      // Filter by class will be implemented later
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _dummyPerformanceData.length,
              itemBuilder: (context, index) {
                final student = _dummyPerformanceData[index];
                final averageScore = student['averageScore'];

                // Determine performance color based on average score
                Color performanceColor;
                if (averageScore >= 90) {
                  performanceColor = Colors.green;
                } else if (averageScore >= 75) {
                  performanceColor = Colors.blue;
                } else if (averageScore >= 60) {
                  performanceColor = Colors.orange;
                } else {
                  performanceColor = Colors.red;
                }

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ExpansionTile(
                    title: Text(
                      student['studentName'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(student['className']),
                    trailing: CircleAvatar(
                      backgroundColor: performanceColor,
                      radius: 20,
                      child: Text(
                        '${averageScore.round()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Test Results:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...List.generate(
                              (student['tests'] as List).length,
                              (testIndex) {
                                final test = student['tests'][testIndex];
                                final score = test['score'];
                                final maxScore = test['maxScore'];
                                final percentage = (score / maxScore * 100)
                                    .round();

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(test['name']),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: LinearProgressIndicator(
                                          value: score / maxScore,
                                          backgroundColor: Colors.grey[300],
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                percentage >= 90
                                                    ? Colors.green
                                                    : percentage >= 75
                                                    ? Colors.blue
                                                    : percentage >= 60
                                                    ? Colors.orange
                                                    : Colors.red,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '$score/$maxScore ($percentage%)',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // View detailed performance report
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Detailed report for ${student['studentName']} coming soon',
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('View Full Report'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Add new performance record
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add performance record functionality coming soon'),
            ),
          );
        },
      ),
    );
  }
}
