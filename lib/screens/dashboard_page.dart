import 'package:abc_erp/screens/project_details_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../widgets/progress_bar.dart';
import '../widgets/status_badge.dart';
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
        centerTitle: true,
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

            /// Quick Project Summary
            const SizedBox(height: 40),
            const Text(
              'Quick Project Summary',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: projectsList.length,
                itemBuilder: (context, index) {
                  final project = projectsList[index];
                  final int budgetTotal = project['budget']['total'];
                  final int budgetSpent = project['budget']['spent'];

                  return _quickSummaryCard(
                    context: context,
                    project: project,
                    budgetTotal: budgetTotal,
                    budgetSpent: budgetSpent,
                  );
                },
              ),
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


Widget _quickSummaryCard({
  required BuildContext context,
  required Map project,
  required int budgetTotal,
  required int budgetSpent,
}) {
  return Container(
    width: 280,
    margin: const EdgeInsets.only(right: 12),
    child: Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProjectDetailsPage(project: project),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Project Name
              Text(
                project['name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              /// Manager
              Row(
                children: [
                  const Text(
                    'Manager: ',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Expanded(
                    child: Text(
                      project['manager']['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              /// Progress
              ProgressBar(
                progress: budgetSpent / budgetTotal,
                color: Colors.greenAccent,
              ),

              const SizedBox(height: 6),

              Text(
                'Budget Used: ${((budgetSpent / budgetTotal) * 100).toStringAsFixed(1)}%',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),

              const Spacer(),

              /// Status
              StatusBadge(status: project['status']),
            ],
          ),
        ),
      ),
    ),
  );
}



