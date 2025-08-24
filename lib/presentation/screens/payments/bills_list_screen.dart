import 'package:flutter/material.dart';

class BillsListScreen extends StatelessWidget {
  const BillsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This is just a placeholder. You would implement the actual bills list here
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bills List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 20,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          // Generate dummy bill data
          final billDate = DateTime.now().subtract(Duration(days: index * 3));
          final formattedDate =
              '${billDate.year}-${billDate.month.toString().padLeft(2, '0')}-${billDate.day.toString().padLeft(2, '0')}';
          final billNumber = 'BILL-${2000 + index}';
          final amount = 2500 + (index % 5) * 500;
          final studentName = 'Student ${index % 7 + 1}';
          final isPaid = index % 3 != 0; // Every 3rd bill is unpaid for demo

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isPaid
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                child: Icon(
                  isPaid ? Icons.receipt : Icons.pending,
                  color: isPaid ? Colors.green.shade800 : Colors.red.shade800,
                ),
              ),
              title: Text('$billNumber - $studentName'),
              subtitle: Text(
                'Date: $formattedDate\nAmount: LKR $amount\nStatus: ${isPaid ? 'Paid' : 'Pending'}',
              ),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () {
                      // View bill details
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.print),
                    onPressed: () {
                      // Print bill
                    },
                  ),
                ],
              ),
              onTap: () {
                // Show bill details
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Generate new bill
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Generate new bill')));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
