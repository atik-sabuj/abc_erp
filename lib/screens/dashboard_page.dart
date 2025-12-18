import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../widgets/progress_bar.dart';
import '../widgets/summary_card.dart';
import 'project_list_page.dart';
import 'payments_page.dart';

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
  List projectsList = [];

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    final jsonString = await rootBundle.loadString('assets/data.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    final company = data['company'];

    companyName = company['name'];
    projectsList = company['projects'];

    totalProjects = projectsList.length;
    totalBudget = 0;
    totalSpent = 0;
    for (var project in projectsList) {
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
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SummaryCard(
                title: 'Total Projects',
                value: totalProjects.toString(),
                icon: Icons.work_outline),
            SummaryCard(
                title: 'Total Budget',
                value: '$totalBudget BDT',
                icon: Icons.account_balance_wallet_outlined),
            SummaryCard(
                title: 'Total Spent',
                value: '$totalSpent BDT',
                icon: Icons.money_off_csred_outlined),
            const SizedBox(height: 20),
            const Text(
              'Budget Utilization',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ProgressBar(progress: totalSpent / totalBudget),
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
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProjectListPage(
                                projects: projectsList)));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text('View Projects')),
            ),
          ],
        ),
      ),
    );
  }
}


