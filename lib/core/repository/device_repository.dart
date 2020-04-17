import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../abstract/abstract.dart';

class DeviceRepository implements DeviceRepositoryAbs {
  DeviceRepository({this.auth, this.firestore});

  final FirebaseAuth auth;
  final Firestore firestore;

  static String path = "devices";

  @override
  Future<bool> saveTokenDevice({String token}) async {
    FirebaseUser firebaseUser = await auth.currentUser();
    return firestore
        .collection(path)
        .document('${firebaseUser.uid}')
        .setData({
          'tokens': FieldValue.arrayUnion([token])
        })
        .then((onValue) => true)
        .catchError((onError) => false);
  }
}
