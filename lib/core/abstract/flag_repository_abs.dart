import 'dart:async';

import '../models/models.dart';

abstract class FlagRepositoryAbs {
  Stream<List<WhiteFlag>> streamFlags();
  Future<bool> createFlag(WhiteFlag newFlag, String mediaPath);
  Future<bool> reportFlag(WhiteFlag flag);
  Future<bool> deleteFlag(WhiteFlag flag);
}
