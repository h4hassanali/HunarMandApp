import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/worker_model.dart';

class WorkerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch all workers
  Future<List<WorkerModel>> fetchWorkers() async {
    final snapshot = await _firestore.collection('workers').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return WorkerModel(
        name: data['name'] ?? '',
        skill: data['skill'] ?? '',
        city: data['city'] ?? '',
        phone: data['phone'] ?? '03XXXXXXXXX',
      );
    }).toList();
  }

  /// Fetch workers filtered by city & skill
  Future<List<WorkerModel>> fetchFilteredWorkers({
    required String city,
    required String skill,
  }) async {
    final snapshot = await _firestore
        .collection('workers')
        .where('city', isEqualTo: city)
        .get();

    final workers = snapshot.docs.map((doc) {
      final data = doc.data();
      return WorkerModel(
        name: data['name'] ?? '',
        skill: data['skill'] ?? '',
        city: data['city'] ?? '',
        phone: data['phone'] ?? '03XXXXXXXXX',
      );
    }).toList();

    return workers
        .where((w) => w.skill.toLowerCase().contains(skill.toLowerCase()))
        .toList();
  }
}
