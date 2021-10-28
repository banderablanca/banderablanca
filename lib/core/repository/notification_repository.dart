import 'package:banderablanca/core/abstract/abstract.dart';
import 'package:banderablanca/core/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationRepository implements NotificationRepositoryAbs {
  NotificationRepository({
    required this.firestore,
    required this.auth,
  });

  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  static String path = 'notifications';

  @override
  Stream<List<UserNotification>> streamNotifications(String uid) {
    return firestore
        .collection(path)
        .doc(uid)
        .collection(path)
        .where('visibility', isEqualTo: 'public')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .handleError((onError) {
      print(onError);
    }).map((snapshot) {
      return snapshot.docs.map((DocumentSnapshot doc) {
        final UserNotification flag =
            UserNotification.fromJson(doc.data() as Map<String, dynamic>);
        return flag.copyWith(id: doc.id);
      }).toList();
    });
  }
}
