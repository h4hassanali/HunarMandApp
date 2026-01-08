import 'package:flutter/material.dart';
import '../models/worker_model.dart';

class WorkerCard extends StatelessWidget {
  final WorkerModel worker;
  final VoidCallback onCall;
  final VoidCallback? onCopy; // optional copy callback

  const WorkerCard({
    super.key,
    required this.worker,
    required this.onCall,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(worker.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Skill: ${worker.skill}'),
            Text('City: ${worker.city}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onCopy != null)
              IconButton(
                icon: const Icon(Icons.copy),
                color: Colors.blue,
                onPressed: onCopy,
                tooltip: 'Copy Phone',
              ),
            IconButton(
              icon: const Icon(Icons.phone),
              color: Colors.green,
              onPressed: onCall,
              tooltip: 'Call Now',
            ),
          ],
        ),
      ),
    );
  }
}
