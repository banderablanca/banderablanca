import 'package:flutter_dotenv/flutter_dotenv.dart';

class RoutePaths {
  static const String Splash = '/';
  static const String LoginScreen = '/login';
  static const String RegisterScreen = '/register';
  static const String ForgotPassword = '/forgotpassword';
  static const String Home = '/home';
  static const String Board = '/board';
  // static const String CreateFlag = '/flag/create';
  // static const String FlagDetail = '/flag';
}

class ApiKeys {
  String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_WEB_API_KEY']!;
}
