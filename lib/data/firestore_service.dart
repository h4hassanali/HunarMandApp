import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/worker_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Save worker registration to Firestore
  Future<void> addWorker(WorkerModel worker) async {
    await _db.collection('workers').add({
      'name': worker.name,
      'phone': worker.phone,
      'skill': worker.skill,
      'city': worker.city,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
