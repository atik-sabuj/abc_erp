import 'package:flutter/material.dart';

class PaymentsPage extends StatelessWidget {
  final Map project;
  const PaymentsPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final List payments = project['payments'] ?? [];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          '${project['name']} Payments',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
                  /// Amount
                  Text(
                    'Amount: ${payment['amount']} BDT',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// Request Info
                  _infoRow('Requested By', payment['requestedBy']),
                  _infoRow('Requested Date', payment['requestDate']),

                  const SizedBox(height: 12),

                  /// Approval Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      color: _statusColor(approval['status'])
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      approval['status'],
                      style: TextStyle(
                        color: _statusColor(approval['status']),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  _infoRow('Approved By', approval['approvedBy']),
                  _infoRow('Approved Date', approval['approvedDate']),

                  const SizedBox(height: 12),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 8),

                  /// Invoices
                  const Text(
                    'Invoices',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  ...List.generate(payment['invoices'].length, (i) {
                    final invoice = payment['invoices'][i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              invoice['vendor'],
                              style: const TextStyle(
                                  color: Colors.grey),
                            ),
                          ),
                          Text(
                            '${invoice['amount']} BDT',
                            style: const TextStyle(
                                color: Colors.white),
                          ),
                        ],
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

  /// Info Row Widget
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(color: Colors.grey),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Status Color Helper
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.greenAccent;
      case 'pending':
        return Colors.orangeAccent;
      case 'rejected':
        return Colors.redAccent;
      default:
        return Colors.blueAccent;
    }
  }
}
