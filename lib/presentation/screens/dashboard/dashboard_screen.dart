import 'package:flutter/material.dart';
import '../attendance/attendance_screen.dart';
import '../classes/classes_list_screen.dart';
import '../payments/payments_dashboard.dart';
import '../performance/student_performance_screen.dart';
import '../profile/profile_screen.dart';
import '../students/students_list_screen.dart';
import '../../widgets/common/app_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const DashboardHomeTab(),
    const ClassesTab(),
    const StudentsTab(),
    const PaymentsTab(),
    const AttendanceTab(),
    const StudentPerformanceTab(),
    const ProfileTab(),
  ];

  void toggleDrawer() {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.closeDrawer();
    } else {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _screens[_selectedIndex],
    );
  }
}

class DashboardHomeTab extends StatelessWidget {
  const DashboardHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SF Institute',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStatCard('Total Classes', '5', Icons.class_, Colors.blue),
                _buildStatCard(
                  'Total Students',
                  '25',
                  Icons.people,
                  Colors.green,
                ),
                _buildStatCard(
                  'Pending Payments',
                  '8',
                  Icons.payment,
                  Colors.orange,
                ),
                _buildStatCard(
                  'This Month Revenue',
                  'LKR 45,000',
                  Icons.monetization_on,
                  Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Recent Activities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildActivityTile(
                    'New student enrolled',
                    'John Doe joined Mathematics Grade 10',
                    Icons.person_add,
                    '2 hours ago',
                  ),
                  _buildActivityTile(
                    'Payment received',
                    'Jane Smith paid for Science Grade 11',
                    Icons.payment,
                    '4 hours ago',
                  ),
                  _buildActivityTile(
                    'Class created',
                    'Physics Grade 12 class created',
                    Icons.add_circle,
                    '1 day ago',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTile(
    String title,
    String subtitle,
    IconData icon,
    String time,
  ) {
    return ListTile(
      leading: CircleAvatar(child: Icon(icon)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }
}

class ClassesTab extends StatelessWidget {
  const ClassesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classes'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to create class screen
            },
          ),
        ],
      ),
      body: const ClassesListScreen(),
    );
  }
}

class StudentsTab extends StatelessWidget {
  const StudentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to create student screen
            },
          ),
        ],
      ),
      body: const StudentsListScreen(),
    );
  }
}

class PaymentsTab extends StatelessWidget {
  const PaymentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Search payments')));
            },
          ),
        ],
      ),
      body: const PaymentsDashboard(),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to the full profile screen
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: const ProfileScreen(),
    );
  }
}

class AttendanceTab extends StatelessWidget {
  const AttendanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const AttendanceScreen();
  }
}

class StudentPerformanceTab extends StatelessWidget {
  const StudentPerformanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const StudentPerformanceScreen();
  }
}
