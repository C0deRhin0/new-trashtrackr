import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/concern.dart';

const String CONCERN_COLLECTION_REF = "userConcerns"; // Updated collection name

class ConcernService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Concern> _concernsRef;

  ConcernService() {
    _concernsRef = _firestore
        .collection(CONCERN_COLLECTION_REF)
        .withConverter<Concern>(
            fromFirestore: (snapshot, _) => Concern.fromJson(snapshot.data()!),
            toFirestore: (concern, _) => concern.toJson());
  }

  Future<void> addConcern(Concern concern) async {
    try {
      await _concernsRef.add(concern);
      print("Concern added successfully.");
    } catch (e) {
      print("Failed to add concern: $e");
    }
  }

  Stream<QuerySnapshot<Concern>> getConcerns() {
    return _concernsRef.snapshots();
  }
}
