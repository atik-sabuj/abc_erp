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

