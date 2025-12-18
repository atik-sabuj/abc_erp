import 'package:flutter/material.dart';

class PaymentsPage extends StatelessWidget {
  final Map project;
  const PaymentsPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final payments = project['payments'] as List;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Payments & Approvals'),
        backgroundColor: Colors.black,
      ),
      body: payments.isEmpty
          ? const Center(
        child: Text(
          'No payments available',
          style: TextStyle(color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final payment = payments[index];
          final approval = payment['approvalFlow'];

          return Card(
            color: const Color(0xFF1E1E1E),
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount: ${payment['amount']} BDT',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Requested By: ${payment['requestedBy']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Requested Date: ${payment['requestDate']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Approval Status: ${approval['status']}',
                    style: const TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Approved By: ${approval['approvedBy']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Approved Date: ${approval['approvedDate']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 8),
                  const Text(
                    'Invoices:',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  ...List.generate(payment['invoices'].length, (i) {
                    final invoice = payment['invoices'][i];
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${invoice['vendor']} - ${invoice['amount']} BDT',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

