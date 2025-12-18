import 'package:flutter/material.dart';

class TaskTeamPage extends StatelessWidget {
  final List projects;

  const TaskTeamPage({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    final project = projects[0];
    final tasks = project['tasks'] as List;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Tasks & Teams'),
        backgroundColor: Colors.black,
      ),
      body: tasks.isEmpty
          ? const Center(
        child: Text(
          'No tasks available',
          style: TextStyle(color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
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
                    task['title'],
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Assigned Team: ',
                          style: TextStyle(color: Colors.grey)),
                      Text(
                        task['assignedTeam'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Priority: ',
                          style: TextStyle(color: Colors.grey)),
                      Text(
                        task['priority'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Progress',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: (task['progress'] as int) / 100,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade800,
                    valueColor:
                    const AlwaysStoppedAnimation(Colors.greenAccent),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${task['progress']}%',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}























/*
import 'package:flutter/material.dart';

import '../widgets/progress_bar.dart';

class TaskTeamPage extends StatelessWidget {
  final List projects;


  const TaskTeamPage({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    final allTasks = _extractAllTasks();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Tasks & Teams',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _taskGroupSection(
            title: 'In Progress',
            tasks: allTasks
                .where((t) => t['progress'] > 0 && t['progress'] < 100)
                .toList(),
          ),
          const SizedBox(height: 20),
          _taskGroupSection(
            title: 'Completed',
            tasks: allTasks.where((t) => t['progress'] == 100).toList(),
          ),
          const SizedBox(height: 20),
          _taskGroupSection(
            title: 'Pending',
            tasks: allTasks.where((t) => t['progress'] == 0).toList(),
          ),
        ],
      ),
    );
  }

  // ================= DATA =================

  List<Map<String, dynamic>> _extractAllTasks() {
    final List<Map<String, dynamic>> tasks = [];

    for (var project in projects) {
      for (var task in project['tasks']) {
        tasks.add({
          ...task,
          'projectName': project['name'],
        });
      }
    }
    return tasks;
  }

  // ================= UI =================

  Widget _taskGroupSection({
    required String title,
    required List tasks,
  }) {
    return _sectionCard(
      title: title,
      child: tasks.isEmpty
          ? const Text(
        'No tasks found',
        style: TextStyle(color: Colors.grey),
      )
          : Column(
        children: tasks.map((task) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Project: ${task['projectName']}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Assigned Team: ${task['assignedTeam']}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _priorityChip(task['priority']),
                    const SizedBox(width: 12),
                    Text(
                      '${task['progress']}%',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ProgressBar(value: task['progress'] / 100),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _priorityChip(String priority) {
    Color color;
    switch (priority) {
      case 'High':
        color = Colors.redAccent;
        break;
      case 'Medium':
        color = Colors.orange;
        break;
      default:
        color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
*/
