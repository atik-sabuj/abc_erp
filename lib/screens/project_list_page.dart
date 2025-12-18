import 'dart:convert';
import 'package:abc_erp/screens/project_details_page.dart';
import 'package:abc_erp/widgets/status_badge.dart';
import 'package:abc_erp/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProjectListPage extends StatefulWidget {
  final List projects; // <-- এখানে parameter define করা হলো

  const ProjectListPage({super.key, required this.projects});

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  late List projects;

  @override
  void initState() {
    super.initState();
    projects = widget.projects; // Dashboard থেকে পাওয়া data assign
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Projects'),
        backgroundColor: Colors.black,
      ),
      body: projects.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          final budgetTotal = project['budget']['total'] as int;
          final budgetSpent = project['budget']['spent'] as int;

          return Card(
            color: const Color(0xFF1E1E1E),
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                project['name'],
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Manager: ',
                          style: TextStyle(color: Colors.grey)),
                      Text(
                        project['manager']['name'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ProgressBar(
                    progress: budgetSpent / budgetTotal,
                    color: Colors.greenAccent,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Budget Utilization: ${((budgetSpent / budgetTotal) * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  StatusBadge(status: project['status']),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProjectDetailsPage(project: project),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

