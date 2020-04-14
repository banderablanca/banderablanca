import 'dart:async';

import '../models/models.dart';

abstract class NotificationRepositoryAbs {
  Stream<List<UserNotification>> streamNotifications(String uid);
}
