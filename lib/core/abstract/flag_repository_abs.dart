import 'dart:async';
import 'dart:io';

import '../models/models.dart';

abstract class FlagRepositoryAbs {
  Stream<List<WhiteFlag>> streamFlags();
  Future<bool> createFlag(WhiteFlag newFlag, String mediaPath);
}
