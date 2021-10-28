import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'constants/app_constants.dart';
import 'provider_setup.dart';
import 'theme.dart';
// import 'ui/helpers/is_in_debug_mode.dart';
import 'ui/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  // Firestore.instance.settings(persistenceEnabled: true, sslEnabled: true);

  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  // Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors to Crashlytics.
  // if (!isInDebugMode)
  //   FlutterError.onError = (FlutterErrorDetails details) {
  //     Crashlytics.instance.recordFlutterError(details);
  //   };
  await DotEnv().load(fileName: '.env');
  runApp(BanderaBlancaApp());
}

class BanderaBlancaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        // onGenerateTitle: (BuildContext context) =>
        //     AppLocalizations.of(context).appTitle,
        title: 'Bandera Blanca',
        theme: AppTheme.theme,
        initialRoute: RoutePaths.Splash,
        onGenerateRoute: RouterApp.generateRoute,
        onUnknownRoute: RouterApp.onUnknownRoute,
        // home: TestScreen(),
      ),
    );
  }
}
