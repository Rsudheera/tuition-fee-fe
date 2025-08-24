import 'package:flutter/material.dart';
import '../../widgets/payments/payment_card.dart';
import 'add_payment_record_screen.dart';
import 'bill_template_screen.dart';
import 'bills_list_screen.dart';
import 'pending_payments_screen.dart';
import 'received_payments_screen.dart';

class PaymentsDashboard extends StatelessWidget {
  const PaymentsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Management',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              PaymentCard(
                title: 'Pending Payments',
                subtitle: 'View all pending payments',
                icon: Icons.pending_actions,
                color: Colors.orange,
                onTap: () {
                  // Navigate to pending payments screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PendingPaymentsScreen(),
                    ),
                  );
                },
                badge: '8',
              ),
              PaymentCard(
                title: 'Add New Record',
                subtitle: 'Create a new payment record',
                icon: Icons.add_circle,
                color: Colors.green,
                onTap: () {
                  // Navigate to add payment screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddPaymentRecordScreen(),
                    ),
                  );
                },
              ),
              PaymentCard(
                title: 'Received Payments',
                subtitle: 'View all received payments',
                icon: Icons.payments,
                color: Colors.blue,
                onTap: () {
                  // Navigate to received payments screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReceivedPaymentsScreen(),
                    ),
                  );
                },
                badge: '35',
              ),
              PaymentCard(
                title: 'Bill Template',
                subtitle: 'Edit bill template',
                icon: Icons.receipt_long,
                color: Colors.purple,
                onTap: () {
                  // Navigate to bill template editor
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BillTemplateScreen(),
                    ),
                  );
                },
              ),
              PaymentCard(
                title: 'Bills List',
                subtitle: 'View all generated bills',
                icon: Icons.list_alt,
                color: Colors.teal,
                onTap: () {
                  // Navigate to bills list
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BillsListScreen(),
                    ),
                  );
                },
                badge: '42',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
