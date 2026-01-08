// lib/data/skill_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class SkillService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch all skills from 'skills' collection
  Future<List<String>> fetchSkills() async {
    final snapshot = await _firestore.collection('skills').get();

    // Extract skill names from each document
    final List<String> skills = snapshot.docs.map((doc) {
      return doc.get('name') as String;
    }).toList();

    // Sort alphabetically (optional)
    skills.sort();
    return skills;
  }
}
