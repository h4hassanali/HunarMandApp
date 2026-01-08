import 'package:cloud_firestore/cloud_firestore.dart';

class CityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch provinces and their cities from Firestore
  Future<Map<String, List<String>>> fetchCities() async {
    final snapshot = await _firestore.collection('cities').get();

    final Map<String, List<String>> result = {};

    for (var doc in snapshot.docs) {
      final province = doc.id;

      // Each document has a field with the same name as the province
      final citiesList = List<String>.from(doc.get(province));
      result[province] = citiesList;
    }

    return result;
  }
}
