import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../ui/views/views.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final splash = SplashScreen();
    final home = HomeScreen();

    switch (settings.name) {
      // case RoutePaths.Splash:
      //   return MaterialPageRoute(builder: (_) => splash);
      // case RoutePaths.RegisterScreen:
      //   return MaterialPageRoute(builder: (_) => RegisterScreen());
      case RoutePaths.Home:
        return MaterialPageRoute(builder: (_) => home);
      // case RoutePaths.ForgotPassword:
      //   return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case RoutePaths.LoginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      default:
        final List<String> path = settings.name.split('/');
        if (path[0] != '') return null;

        // TeamDetail screen
        if (isPathNameWithRoute(settings, RoutePaths.TeamDetails)) {
          String _id = getIdByPath(settings);
          return MaterialPageRoute(builder: (_) => FlagDetail(flagId: _id));
        }
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      ),
    );
  }

  static bool isPathNameWithRoute(RouteSettings settings, String pathName) {
    final List<String> path = settings.name.split('/');
    final List<String> pathScreen = pathName.split('/');
    if (path[0] != '' || pathScreen[0] != '') return false;
    if (path[1].startsWith(pathScreen[1])) {
      if (path.length != 3) return false;
      return true;
    }
    return false;
  }

  static String getIdByPath(RouteSettings settings) {
    final List<String> path = settings.name.split('/');
    if (path[0] != '' || path.length != 3) return null;
    final List<String> id = path[2].split('#');
    return id[0];
  }

  /// Ejemplo de llamada para un tab en específico:
  /// /{routeName}/{id}#{initialTabIndex}
  /// example:
  ///     /screen/ID0001#1
  static int getTabByPath(RouteSettings settings) {
    final List<String> path = settings.name.split('#');
    return path[1] != "null" ? int.parse(path.last) : 0;
  }
}
