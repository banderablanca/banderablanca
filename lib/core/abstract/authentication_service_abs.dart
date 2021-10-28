import 'dart:async';
import 'dart:typed_data';

import '../models/models.dart';

abstract class AuthenticationServiceAbs {
  Future<UserApp> signInWithEmailAndPassword(AuthFormData authForm);
  Future<bool> sendEmailVerification();
  Future<UserApp> handleSignIn();
  Future<UserApp> createUserWithEmailAndPassword(AuthFormData authForm);
  Future<Null> sendPasswordResetEmail(AuthFormData authForm);

  Stream<UserApp> loadUserData(UserApp currentUser);
  Future<UserApp> updateUserProfile(UserApp userApp);
  Future<String> updatePhoto(String path, Uint8List file);
  Future<bool> logout();
  Future<bool> onBoardCompleted();
  Stream<UserApp?> get onAuthStateChanged;
}
