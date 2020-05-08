import 'dart:io';
import 'dart:typed_data';

import 'package:banderablanca/ui/helpers/show_confirm_dialog.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../repository/authentication_service.dart';
import '../abstract/abstract.dart';
import '../models/models.dart';
import '../core.dart';
import 'base_model.dart';
import 'package:flutter/services.dart';

class UserModel extends BaseModel {
  AuthenticationServiceAbs _repository;
  StorageRepositoryAbs _storage;
  UserApp _currentUser;
  String errorMessage = '';
  AuthenticationService get authenticationService => _repository;
  UserApp get currentUser => _currentUser;

  set storage(store) {
    _storage = store;
  }

  set authenticationService(AuthenticationService authenticationService) {
    _repository = authenticationService;
    notifyListeners();
  }

  set currentUser(user) {
    if (_currentUser == null) {
      _currentUser = user;
      _handleSignIn();
      notifyListeners();
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  versionCheck(context) async {
    if(!kReleaseMode) return;
    try {
      PackageInfo info = await PackageInfo.fromPlatform();
      final RemoteConfig remoteConfig = await RemoteConfig.instance;
      final String currentBuildNumber = "${info.version}.${info.buildNumber}";
      final String configName = Platform.isIOS ? 'ios_app' : 'android_app';
      final defaults = <String, dynamic>{
        '${configName}_version': '$currentBuildNumber',
        '${configName}_url': 'https://bandera-blanca.web.app'
      };

      await remoteConfig.setDefaults(defaults);
      await remoteConfig.fetch(expiration: const Duration(seconds: 1));
      await remoteConfig.activateFetched();

      final requiredBuildNumber =
          remoteConfig.getString('${configName}_version');
      final urlStore = remoteConfig.getString('${configName}_url');
      if (requiredBuildNumber != currentBuildNumber) {
        // versionDialog(context);
        await showConfirmDialog(context,
            title: "Hay una versión nueva",
            content: "Las actualizaciones traen novedades",
            cancelText: null,
            confirmText: "Actualizar");
        _launchURL(urlStore);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> refreshProfile() async {
    try {
      // setState(ViewState.Busy);
      _currentUser = await _repository.handleSignIn();
      notifyListeners();
      loadUserData();
    } on PlatformException catch (error) {
      errorMessage = '${error.message}';
      // setState(ViewState.Idle);
    }
    return true;
  }

  Future _handleSignIn() async {
    try {
      setState(ViewState.Busy);
      _currentUser = await _repository.handleSignIn();
      loadUserData();
    } on PlatformException catch (error) {
      errorMessage = '${error.message}';
      setState(ViewState.Idle);
    }
  }

  Future logout() async {
    try {
      setState(ViewState.Busy);
      await _repository.logout();
      _currentUser = null;
      notifyListeners();
    } on PlatformException catch (error) {
      errorMessage = '${error.message}';
    } finally {
      setState(ViewState.Idle);
    }
  }

  Future signInWithEmailAndPassword(AuthFormData authForm) async {
    try {
      setState(ViewState.Busy);
      currentUser = await _repository.signInWithEmailAndPassword(authForm);
    } on PlatformException catch (error) {
      errorMessage = '${error.message}';
    } finally {
      setState(ViewState.Idle);
    }
  }

  Future createUserWithEmailAndPassword(AuthFormData authForm) async {
    try {
      setState(ViewState.Busy);
      currentUser = await _repository.createUserWithEmailAndPassword(authForm);
    } on PlatformException catch (error) {
      errorMessage = '${error.message}';
    } finally {
      setState(ViewState.Idle);
    }
  }

  Future sendPasswordResetEmail(AuthFormData authForm) async {
    try {
      setState(ViewState.Busy);
      await _repository.sendPasswordResetEmail(authForm);
    } on PlatformException catch (error) {
      errorMessage = '${error.message}';
    } finally {
      setState(ViewState.Idle);
    }
  }

  loadUserData() {
    _repository.loadUserData(_currentUser).listen((userApp) {
      // store.dispatch(LoadUserDataSuccessAction(userApp));
      _currentUser = currentUser.copyWith(
        languageCode: userApp.languageCode,
        onBoardCompleted: userApp.onBoardCompleted,
      );
      setState(ViewState.Idle);
      notifyListeners();
    }).onError((handleError) {
      // store.dispatch(LoadUserDataError(handleError));
    });
  }

  updateUserProfile(UserApp userApp) {
    _repository.updateUserProfile(userApp).then((userApp) {
      // _currentUser = userApp.copyWith(displayName: action.userApp.displayName)
    });
  }

  updateName(String name) async {
    setState(ViewState.Busy);
    _currentUser = await _repository
        .updateUserProfile(currentUser.copyWith(displayName: name));
    setState(ViewState.Idle);
    notifyListeners();
  }

  updatePhoto(String path, Uint8List data) async {
    setState(ViewState.Busy);
    final String photoUrl = await _repository.updatePhoto(path, data);
    _currentUser = _currentUser.copyWith(photoUrl: photoUrl);
    notifyListeners();
    setState(ViewState.Idle);
  }

  sendEmailVerification() async {
    setState(ViewState.Busy);
    await _repository.sendEmailVerification();
    setState(ViewState.Idle);
  }

  onBoardCompleted() => _repository.onBoardCompleted();
}
