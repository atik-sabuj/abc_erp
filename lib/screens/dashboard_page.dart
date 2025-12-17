import 'dart:convert';
import 'package:abc_erp/screens/project_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isLoading = true;

  String companyName = '';
  int totalProjects = 0;
  int totalBudget = 0;
  int totalSpent = 0;

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    final jsonString =
    await rootBundle.loadString('assets/data.json');
    final Map<String, dynamic> data = json.decode(jsonString);

    final company = data['company'];
    final projects = company['projects'] as List;

    companyName = company['name'];
    totalProjects = projects.length;

    for (var project in projects) {
      totalBudget += project['budget']['total'] as int;
      totalSpent += project['budget']['spent'] as int;
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          companyName.isEmpty ? 'Dashboard' : companyName,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.white),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _summaryCard(
              title: 'Total Projects',
              value: totalProjects.toString(),
              icon: Icons.work_outline,
            ),
            _summaryCard(
              title: 'Total Budget',
              value: '$totalBudget BDT',
              icon: Icons.account_balance_wallet_outlined,
            ),
            _summaryCard(
              title: 'Total Spent',
              value: '$totalSpent BDT',
              icon: Icons.money_off_csred_outlined,
            ),

            const SizedBox(height: 20),

            const Text(
              'Budget Utilization',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                minHeight: 10,
                value: totalSpent / totalBudget,
                backgroundColor: Colors.grey.shade800,
                valueColor: const AlwaysStoppedAnimation(
                  Colors.greenAccent,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '${((totalSpent / totalBudget) * 100).toStringAsFixed(1)}%',
              style: const TextStyle(color: Colors.grey),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'View Projects',
                  style: TextStyle(color: Colors.white),
                ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProjectListPage()),
                    );
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
