import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'storage_repository.dart';
import '../abstract/abstract.dart';
import '../models/models.dart';
import 'package:meta/meta.dart';

class AuthenticationService implements AuthenticationServiceAbs {
  AuthenticationService({
    @required this.auth,
    @required this.firestore,
    @required this.storage,
  });

  final FirebaseAuth auth;
  final Firestore firestore;
  final FirebaseStorage storage;

  static String path = "users";

  Future<UserApp> _userFromFirebase(FirebaseUser _user) async {
    if (_user == null) {
      return null;
    }

    // IdTokenResult token = await _user.getIdToken();
    final userData = await _loadUserData(_user.uid);
    final UserApp currentUser = UserApp(
      id: _user.uid,
      country: 'PE',
      email: _user.email,
      displayName: _user.displayName,
      photoUrl: _user.photoUrl,
      onBoardCompleted: userData.onBoardCompleted,
    );

    return currentUser;
  }

  @override
  Stream<UserApp> get onAuthStateChanged {
    return auth.onAuthStateChanged.asyncMap(_userFromFirebase);
  }

  @override
  Future<UserApp> createUserWithEmailAndPassword(AuthFormData authForm) async {
    final AuthResult authResult = await auth.createUserWithEmailAndPassword(
      email: authForm.email,
      password: authForm.password,
    );
    final FirebaseUser firebaseUser = authResult.user;

    assert(firebaseUser != null);
    assert(await firebaseUser.getIdToken() != null);
    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = authForm.displayName;
    userUpdateInfo.photoUrl =
        'https://futbol-social-avatar.herokuapp.com/avatars/200/${firebaseUser.uid}.png';
    await firebaseUser.updateProfile(userUpdateInfo);
    await firebaseUser.reload();
    final FirebaseUser _user = await auth.currentUser();
    // create /users/{UID}
    await firestore
        .collection(path)
        .document('${_user.uid}')
        .setData({"language_code": authForm.languageCode}, merge: true);

    return UserApp(
      id: _user.uid,
      country: 'PE',
      email: _user.email,
      displayName: _user.displayName,
      photoUrl: _user.photoUrl,
      languageCode: authForm.languageCode,
    );
  }

  @override
  Future<UserApp> handleSignIn() async {
    FirebaseUser firebaseUser = await auth.currentUser();
    if (firebaseUser == null) await auth.signInAnonymously();
    assert(firebaseUser != null);
    await firebaseUser.reload();
    return Future.value(UserApp(
      id: firebaseUser.uid,
      country: 'PE',
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoUrl,
      isEmailVerified: firebaseUser.isEmailVerified,
    ));
  }

  @override
  Future<bool> sendEmailVerification() async {
    FirebaseUser firebaseUser = await auth.currentUser();
    assert(firebaseUser != null);
    assert(!firebaseUser.isAnonymous);
    firebaseUser.sendEmailVerification();
    return true;
  }

  @override
  Future<UserApp> signInWithEmailAndPassword(AuthFormData authForm) async {
    final AuthResult authResult = await auth.signInWithEmailAndPassword(
        email: authForm.email, password: authForm.password);
    final FirebaseUser firebaseUser = authResult.user;

    assert(firebaseUser != null);
    assert(await firebaseUser.getIdToken() != null);

    final FirebaseUser currentUser = await auth.currentUser();
    assert(firebaseUser.uid == currentUser.uid);

    return UserApp(
      id: firebaseUser.uid,
      country: 'PE',
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoUrl,
    );
  }

  @override
  Future<Null> sendPasswordResetEmail(AuthFormData authForm) async {
    return await auth.sendPasswordResetEmail(email: authForm.email);
  }

  Future<UserApp> _loadUserData(String uid) async {
    return firestore.collection(path).document('$uid').get().then((snapshot) {
      if (snapshot.exists) return UserApp.fromJson(snapshot.data);
      return null;
    });
  }

  @override
  Stream<UserApp> loadUserData(UserApp currentUser) {
    return firestore
        .collection(path)
        .document('${currentUser.id}')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) return UserApp.fromJson(snapshot.data);
      return UserApp();
    });
  }

  @override
  Future<UserApp> updateUserProfile(UserApp userApp) async {
    final FirebaseUser firebaseUser = await auth.currentUser();

    assert(firebaseUser != null);
    assert(await firebaseUser.getIdToken() != null);
    // update /users/{uid}
    // _changeLanguage(userApp);

    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = userApp.displayName;

    await firebaseUser.updateProfile(userUpdateInfo);
    await firebaseUser.reload();
    final FirebaseUser _user = await auth.currentUser();
    return Future.value(
      userApp.copyWith(
        displayName: _user.displayName,
        photoUrl: _user.photoUrl,
      ),
    );
  }

  @override
  Future<bool> logout() async {
    try {
      final FirebaseUser firebaseUser = await auth.currentUser();
      await auth.signOut();
      await firebaseUser.reload();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> updatePhoto(String path, Uint8List file) async {
    final FirebaseUser firebaseUser = await auth.currentUser();

    assert(firebaseUser != null);
    assert(await firebaseUser.getIdToken() != null);

    StorageRepository storageRepository = StorageRepository(storage);
    String uploadUrl = await storageRepository.uploadPhotoProfile(
        path, file, firebaseUser.uid);
    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = firebaseUser.displayName;
    userUpdateInfo.photoUrl = uploadUrl;

    await firebaseUser.updateProfile(userUpdateInfo);
    await firebaseUser.reload();
    final FirebaseUser _user = await auth.currentUser();
    return _user.photoUrl;
  }

  @override
  Future<bool> onBoardCompleted() async {
    final FirebaseUser firebaseUser = await auth.currentUser();

    assert(firebaseUser != null);
    assert(await firebaseUser.getIdToken() != null);
    await firestore
        .collection(path)
        .document('${firebaseUser.uid}')
        .setData({"on_board_completed": true}, merge: true);
    return true;
  }
}
