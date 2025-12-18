import 'package:abc_erp/screens/payments_page.dart';
import 'package:abc_erp/screens/task_team_page.dart';
import 'package:abc_erp/widgets/progress_bar.dart';
import 'package:abc_erp/widgets/status_badge.dart';
import 'package:flutter/material.dart';

class ProjectDetailsPage extends StatelessWidget {
  final Map project;
  const ProjectDetailsPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final budget = project['budget'];
    final totalBudget = budget['total'] as int;
    final spentBudget = budget['spent'] as int;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(project['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Project Basic Info
            Card(
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusBadge(status: project['status']),
                    const SizedBox(height: 12),
                    Text('Project Manager: ${project['manager']['name']}',
                        style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('Start: ${project['timeline']['startDate']}',
                        style: const TextStyle(color: Colors.grey)),
                    Text('End: ${project['timeline']['endDate']}',
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Budget Breakdown
            Card(
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Budget Breakdown', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ProgressBar(progress: spentBudget / totalBudget, color: Colors.greenAccent),
                    const SizedBox(height: 4),
                    Text('Total: $totalBudget BDT', style: const TextStyle(color: Colors.grey)),
                    Text('Spent: $spentBudget BDT', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12),
                    ...List.generate(budget['categories'].length, (index) {
                      final cat = budget['categories'][index];
                      final catProgress = cat['spent'] / cat['allocated'];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${cat['name']}: ${cat['spent']} / ${cat['allocated']} BDT',
                                style: const TextStyle(color: Colors.white)),
                            const SizedBox(height: 4),
                            ProgressBar(progress: catProgress, color: Colors.orangeAccent, height: 6),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tasks
            Card(
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tasks', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...List.generate(project['tasks'].length, (index) {
                      final task = project['tasks'][index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task['title'], style: const TextStyle(color: Colors.white)),
                          const SizedBox(height: 4),
                          ProgressBar(progress: (task['progress'] as int) / 100, color: Colors.blueAccent, height: 6),
                          const SizedBox(height: 8),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // View Task & Team Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                child: const Text('View Tasks & Teams'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskTeamPage(projects: [project]),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Payments Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                child: const Text('View Payments & Approvals'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentsPage(project: project),
                    ),
                  );
                },
              ),

            ),
          ],
        ),
      ),
    );
  }
}


