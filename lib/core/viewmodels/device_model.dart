import '../abstract/abstract.dart';

import 'base_model.dart';

class DeviceModel extends BaseModel {
  DeviceModel(this._repository);
  final DeviceRepositoryAbs _repository;

  // set repository(repo) {
  //   _repository = repo;
  // }

  saveToken(String token) {
    _repository.saveTokenDevice(token: token);
  }
}
