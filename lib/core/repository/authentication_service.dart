import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../abstract/abstract.dart';
import '../models/models.dart';
import 'storage_repository.dart';

class AuthenticationService implements AuthenticationServiceAbs {
  AuthenticationService({
    required this.auth,
    required this.firestore,
    required this.storage,
  });

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  static String path = "users";

  Future<UserApp?> _userFromFirebase(User? _user) async {
    if (_user == null) {
      return null;
    }

    // IdTokenResult token = await _user.getIdToken();
    bool onBoardCompleted = await _loadUserData(_user.uid);
    final UserApp currentUser = UserApp(
      id: _user.uid,
      country: 'PE',
      email: _user.email ?? '',
      displayName: _user.displayName ?? '',
      photoUrl: _user.photoURL ?? '',
      onBoardCompleted: onBoardCompleted,
      languageCode: "es_PE",
      isEmailVerified: false,
    );

    return currentUser;
  }

  @override
  Stream<UserApp?> get onAuthStateChanged {
    // return auth.authStateChanges.asyncMap(_userFromFirebase);
    return auth.authStateChanges().asyncMap(_userFromFirebase);
  }

  @override
  Future<UserApp> createUserWithEmailAndPassword(AuthFormData authForm) async {
    final UserCredential authResult = await auth.createUserWithEmailAndPassword(
      email: authForm.email,
      password: authForm.password,
    );
    // if (authResult.user == null) return null;
    final User? firebaseUser = authResult.user;

    assert(firebaseUser != null);
    assert(await firebaseUser?.getIdToken() != null);
    // UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    // userUpdateInfo.displayName = authForm.displayName;
    // userUpdateInfo.photoUrl =
    //     'https://futbol-social-avatar.herokuapp.com/avatars/200/${firebaseUser.uid}.png';
    await firebaseUser!.updateDisplayName(authForm.displayName);
    await firebaseUser.updatePhotoURL(
        'https://futbol-social-avatar.herokuapp.com/avatars/200/${firebaseUser.uid}.png');
    await firebaseUser.reload();
    final User? _user = auth.currentUser;
    // create /users/{UID}
    await firestore
        .collection(path)
        .doc('${_user!.uid}')
        .set({"language_code": authForm.languageCode}, SetOptions(merge: true));

    return UserApp(
      id: _user.uid,
      country: 'PE',
      email: _user.email ?? '',
      displayName: _user.displayName ?? '',
      photoUrl: _user.photoURL ?? '',
      languageCode: authForm.languageCode,
    );
  }

  @override
  Future<UserApp> handleSignIn() async {
    User? firebaseUser = auth.currentUser;
    if (firebaseUser == null) {
      UserCredential result = await auth.signInAnonymously();
      firebaseUser = result.user;
    }
    return Future.value(UserApp(
      id: firebaseUser!.uid,
      country: 'PE',
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
      photoUrl: firebaseUser.photoURL ?? '',
      isEmailVerified: false,
      onBoardCompleted: false,
    ));
  }

  @override
  Future<bool> sendEmailVerification() async {
    User? firebaseUser = auth.currentUser;
    assert(firebaseUser != null);
    assert(!firebaseUser!.isAnonymous);
    firebaseUser!.sendEmailVerification();
    return true;
  }

  @override
  Future<UserApp> signInWithEmailAndPassword(AuthFormData authForm) async {
    final UserCredential authResult = await auth.signInWithEmailAndPassword(
        email: authForm.email, password: authForm.password);
    final User? firebaseUser = authResult.user;

    assert(firebaseUser != null);
    // assert(await firebaseUser!.getIdToken() != null);

    final User? currentUser = auth.currentUser;
    assert(firebaseUser!.uid == currentUser!.uid);

    return UserApp(
      id: firebaseUser!.uid,
      country: 'PE',
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
      photoUrl: firebaseUser.photoURL ?? '',
    );
  }

  @override
  Future<Null> sendPasswordResetEmail(AuthFormData authForm) async {
    await auth.sendPasswordResetEmail(email: authForm.email);
    return;
  }

  Future<bool> _loadUserData(String uid) async {
    return firestore.collection(path).doc('$uid').get().then((snapshot) {
      Map<String, dynamic> d = snapshot.data() as Map<String, dynamic>;
      if (snapshot.exists) {
        // return UserApp.fromJson(d);
        return snapshot.get("on_board_completed") ?? false;
      }
      return false;
    });
  }

  @override
  Stream<UserApp> loadUserData(UserApp currentUser) {
    return firestore
        .collection(path)
        .doc('${currentUser.id}')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists)
        return UserApp.fromJson(snapshot.data() as Map<String, dynamic>);
      return UserApp(
        id: "",
        displayName: "",
        email: "",
        photoUrl: "",
        isEmailVerified: false,
      );
    });
  }

  @override
  Future<UserApp> updateUserProfile(UserApp userApp) async {
    final User? firebaseUser = auth.currentUser;

    assert(firebaseUser != null);
    // assert(await firebaseUser.getIdToken() != null);
    // update /users/{uid}
    // _changeLanguage(userApp);

    // UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    // userUpdateInfo.displayName = userApp.displayName;
    await firebaseUser!.updateDisplayName(userApp.displayName);
    // await firebaseUser.updateProfile(userUpdateInfo);
    await firebaseUser.reload();
    final User? _user = auth.currentUser;
    return Future.value(
      userApp.copyWith(
        displayName: _user!.displayName ?? '',
        photoUrl: _user.photoURL ?? '',
      ),
    );
  }

  @override
  Future<bool> logout() async {
    try {
      final User? firebaseUser = auth.currentUser;
      await auth.signOut();
      await firebaseUser!.reload();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> updatePhoto(String path, Uint8List file) async {
    final User? firebaseUser = auth.currentUser;

    assert(firebaseUser != null);
    // assert(await firebaseUser!.getIdToken() != null);

    StorageRepository storageRepository = StorageRepository(storage);
    String uploadUrl = await storageRepository.uploadPhotoProfile(
        path, file, firebaseUser!.uid);
    // UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    // userUpdateInfo.displayName = firebaseUser.displayName;
    // userUpdateInfo.photoUrl = uploadUrl;

    await firebaseUser.updateDisplayName(firebaseUser.displayName);
    await firebaseUser.updatePhotoURL(uploadUrl);
    await firebaseUser.reload();
    final User? _user = auth.currentUser;
    return _user!.photoURL ?? '';
  }

  @override
  Future<bool> onBoardCompleted() async {
    final User? firebaseUser = auth.currentUser;

    assert(firebaseUser != null);
    // assert(await firebaseUser.getIdToken() != null);
    await firestore.collection(path).doc('${firebaseUser!.uid}').set(
      {"on_board_completed": true},
      SetOptions(merge: true),
    );
    return true;
  }
}
