import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../abstract/abstract.dart';

class DeviceRepository implements DeviceRepositoryAbs {
  DeviceRepository({
    required this.auth,
    required this.firestore,
  });

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  static String path = "devices";

  @override
  Future<bool> saveTokenDevice({String? token}) async {
    User? firebaseUser = auth.currentUser;
    return firestore
        .collection(path)
        .doc('${firebaseUser!.uid}')
        .set({
          'tokens': FieldValue.arrayUnion([token])
        })
        .then((onValue) => true)
        .catchError((onError) => false);
  }
}
