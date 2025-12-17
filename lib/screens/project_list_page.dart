import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  bool isLoading = true;
  List projects = [];

  @override
  void initState() {
    super.initState();
    loadProjects();
  }

  Future<void> loadProjects() async {
    final jsonString =
    await rootBundle.loadString('assets/data.json');
    final Map<String, dynamic> data = json.decode(jsonString);

    projects = data['company']['projects'] as List;

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // 👈 This makes back button white
        title: const Text(
          'Projects',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.white),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          final totalBudget = project['budget']['total'];
          final spentBudget = project['budget']['spent'];
          final utilization = spentBudget / totalBudget;

          return Card(
            color: const Color(0xFF1E1E1E),
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                // 🔜 Navigate to Project Details Page
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Project Name & Status
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            project['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _statusBadge(project['status']),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // 🔹 Project Manager
                    Text(
                      'Manager: ${project['manager']['name']}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 🔹 Budget Utilization
                    const Text(
                      'Budget Utilization',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        value: utilization,
                        backgroundColor:
                        Colors.grey.shade800,
                        valueColor:
                        const AlwaysStoppedAnimation(
                          Colors.greenAccent,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      '${(utilization * 100).toStringAsFixed(1)}% '
                          '(${spentBudget} / ${totalBudget} BDT)',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 🔹 Status Badge Widget
  Widget _statusBadge(String status) {
    Color color;

    switch (status) {
      case 'Completed':
        color = Colors.green;
        break;
      case 'In Progress':
        color = Colors.blueAccent;
        break;
      case 'Planning':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
