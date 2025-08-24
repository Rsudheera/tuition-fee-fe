import 'package:flutter/material.dart';

class AddPaymentRecordScreen extends StatefulWidget {
  const AddPaymentRecordScreen({super.key});

  @override
  State<AddPaymentRecordScreen> createState() => _AddPaymentRecordScreenState();
}

class _AddPaymentRecordScreenState extends State<AddPaymentRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedStudent;
  String? _selectedClass;
  final _amountController = TextEditingController();
  final _dateController = TextEditingController(
    text: DateTime.now().toString().substring(0, 10),
  );
  String _paymentMethod = 'Cash';

  // Dummy data
  final List<String> _students = [
    'John Doe',
    'Jane Smith',
    'Bob Johnson',
    'Alice Williams',
    'Charlie Brown',
  ];

  final List<String> _classes = [
    'Mathematics Grade 10',
    'Science Grade 11',
    'Physics Grade 12',
    'Chemistry Grade 11',
    'Biology Grade 12',
  ];

  final List<String> _paymentMethods = [
    'Cash',
    'Bank Transfer',
    'Online Payment',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Payment Record')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Student',
                  border: OutlineInputBorder(),
                ),
                value: _selectedStudent,
                items: _students.map((student) {
                  return DropdownMenuItem<String>(
                    value: student,
                    child: Text(student),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStudent = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a student';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Class',
                  border: OutlineInputBorder(),
                ),
                value: _selectedClass,
                items: _classes.map((className) {
                  return DropdownMenuItem<String>(
                    value: className,
                    child: Text(className),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedClass = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a class';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (LKR)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) {
                    setState(() {
                      _dateController.text = date.toString().substring(0, 10);
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                ),
                value: _paymentMethod,
                items: _paymentMethods.map((method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process payment data
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Payment record saved')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Payment Record'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
