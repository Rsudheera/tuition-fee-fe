import 'package:flutter/material.dart';

class BillTemplateScreen extends StatefulWidget {
  const BillTemplateScreen({super.key});

  @override
  State<BillTemplateScreen> createState() => _BillTemplateScreenState();
}

class _BillTemplateScreenState extends State<BillTemplateScreen> {
  final _formKey = GlobalKey<FormState>();

  // Demo template data
  String _headerText = 'SF Institute';
  String _footerText = 'Thank you for your payment!';
  bool _includeStudentInfo = true;
  bool _includeClassInfo = true;
  bool _includePaymentHistory = false;
  final String _logoPath =
      'assets/images/logo.png'; // This is just a placeholder path

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Template'),
        actions: [
          IconButton(
            icon: const Icon(Icons.preview),
            onPressed: () {
              // Show template preview
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Showing bill preview')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bill Template Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: _headerText,
                decoration: const InputDecoration(
                  labelText: 'Header Text',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _headerText = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _footerText,
                decoration: const InputDecoration(
                  labelText: 'Footer Text',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _footerText = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text('Logo', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: _logoPath.isNotEmpty
                          ? Image.asset(
                              _logoPath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Text('Logo Preview');
                              },
                            )
                          : const Text('No Logo'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Upload logo functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Upload logo functionality'),
                        ),
                      );
                    },
                    child: const Text('Upload Logo'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Bill Content',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Include Student Information'),
                value: _includeStudentInfo,
                onChanged: (value) {
                  setState(() {
                    _includeStudentInfo = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Include Class Information'),
                value: _includeClassInfo,
                onChanged: (value) {
                  setState(() {
                    _includeClassInfo = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Include Payment History'),
                value: _includePaymentHistory,
                onChanged: (value) {
                  setState(() {
                    _includePaymentHistory = value;
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
                      // Save template
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Template saved successfully'),
                        ),
                      );
                    }
                  },
                  child: const Text('Save Template'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
