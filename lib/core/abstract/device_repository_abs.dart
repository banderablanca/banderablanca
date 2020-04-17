import 'package:meta/meta.dart';

abstract class DeviceRepositoryAbs {
  Future<bool> saveTokenDevice({@required String token});
}
