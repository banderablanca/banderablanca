import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/core.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

List<SingleChildWidget> get providers => [
      ...independentServices,
      ...uiConsumableProviders,
      ...dependentServices,
    ];

List<SingleChildWidget> independentServices = [
  Provider(
      create: (_) => AuthenticationService(
          auth: _auth, firestore: _firestore, storage: _storage)),
  Provider(create: (_) => StorageRepository(_storage)),
  Provider(
    create: (_) =>
        FlagRepository(auth: _auth, firestore: _firestore, storage: _storage),
  ),
  Provider(
    create: (_) => MessageRepository(
        auth: _auth, firestore: _firestore, storage: _storage),
  ),
  Provider(
    create: (_) => NotificationRepository(auth: _auth, firestore: _firestore),
  ),
  Provider(
    create: (_) => DeviceRepository(auth: _auth, firestore: _firestore),
  ),
];

List<SingleChildWidget> dependentServices = [
  ChangeNotifierProvider(
    create: (_) => TabModel(),
  ),
  ChangeNotifierProvider(
    create: (BuildContext context) =>
        UserModel(repository: context.read<AuthenticationService>()),
    // update: (_, user, model) => model
    // ..authenticationService = auth
    // ..currentUser = user,
  ),
  ChangeNotifierProvider(
    create: (BuildContext context) => MessageModel(
      repository: context.read<MessageRepository>(),
    ),
  ),
  // ChangeNotifierProxyProvider2<MessageRepository, UserApp, MessageModel>(
  //   create: (_) => MessageModel(),
  //   update: (_, repository, user, model) => model
  //     ..repository = repository
  //     ..currentUser = user,
  // ),
  ChangeNotifierProvider(
    create: (BuildContext context) => FlagModel(
      repository: context.read<FlagRepository>(),
    ),
  ),
  // ChangeNotifierProxyProvider<FlagRepository, FlagModel>(
  //   create: (_) => FlagModel(),
  //   update: (_, repository, model) => model..repository = repository,
  // ),
  ChangeNotifierProvider(
    create: (BuildContext context) =>
        NotificationModel(context.read<NotificationRepository>()),
    // update: (_, user, model) => model!..user = user,
  ),
  ChangeNotifierProvider(
      create: (BuildContext context) =>
          DeviceModel(context.read<DeviceRepository>())),
  // ChangeNotifierProxyProvider<DeviceRepository, DeviceModel>(
  //   create: (_) => DeviceModel(),
  //   update: (_, repository, model) => model..repository = repository,
  // ),
];

List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<UserApp?>(
    initialData: null,
    create: (BuildContext context) =>
        context.read<AuthenticationService>().onAuthStateChanged,
  ),
];
