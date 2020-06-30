import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/core.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;
final Firestore _firestore = Firestore.instance;

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
  ChangeNotifierProxyProvider3<AuthenticationService, UserApp,
      StorageRepository, UserModel>(
    create: (_) => UserModel(),
    update: (_, auth, user, storage, model) => model
      ..authenticationService = auth
      ..currentUser = user,
  ),
  ChangeNotifierProxyProvider2<MessageRepository, UserApp, MessageModel>(
    create: (_) => MessageModel(),
    update: (_, repository, user, model) => model
      ..repository = repository
      ..currentUser = user,
  ),
  ChangeNotifierProxyProvider<FlagRepository, FlagModel>(
    create: (_) => FlagModel(),
    update: (_, repository, model) => model..repository = repository,
  ),
  ChangeNotifierProxyProvider2<NotificationRepository, UserApp,
      NotificationModel>(
    create: (_) => NotificationModel(),
    update: (_, repository, user, model) => model
      ..user = user
      ..repository = repository,
  ),
  ChangeNotifierProxyProvider<DeviceRepository, DeviceModel>(
    create: (_) => DeviceModel(),
    update: (_, repository, model) => model..repository = repository,
  ),
];

List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<UserApp>(
    create: (context) =>
        Provider.of<AuthenticationService>(context, listen: false)
            .onAuthStateChanged,
  ),
];
