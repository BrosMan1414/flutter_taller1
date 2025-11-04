import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/university.dart';

class UniversityService {
  final CollectionReference _col = FirebaseFirestore.instance.collection(
    'universidades',
  );

  Stream<List<University>> streamUniversities() {
    return _col
        .orderBy('nombre')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (d) =>
                    University.fromMap(d.id, d.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  Future<void> createUniversity(University u) async {
    final id = u.nit.replaceAll(RegExp(r'[^0-9A-Za-z]'), '');
    await _col.doc(id).set(u.toMap());
  }

  Future<void> updateUniversity(String id, Map<String, dynamic> data) async {
    await _col.doc(id).update(data);
  }

  Future<void> deleteUniversity(String id) async {
    await _col.doc(id).delete();
  }

  Future<University?> getUniversity(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return University.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }
}
