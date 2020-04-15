import '../../core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'onboard/onboard_screen.dart';
import 'views.dart';
import 'widgets/widgets.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: FirebaseAuth.instance.onAuthStateChanged,
      updateShouldNotify: (FirebaseUser previous, FirebaseUser current) =>
          previous != current,
      child: RedirectionWidget(),
    );
  }
}

class RedirectionWidget extends StatelessWidget {
  Widget get _showLoadIndicator => Scaffold(body: SplashLoading());
  @override
  Widget build(BuildContext context) {
    return Selector<UserModel, UserApp>(
      child: HomeScreen(),
      // builder: (BuildContext context, UserModel model, Widget child) {
      //   if (model.state == ViewState.Busy) return _showLoadIndicator;

      //   if (model.currentUser != null) {
      //     if (model.currentUser.onBoardCompleted == null ||
      //         !model.currentUser.onBoardCompleted) return OnBoardingScreen();
      //     return child;
      //   } else {
      //     return LoginScreen();
      //   }
      // },
      selector: (_, UserModel model) => model.currentUser,
      builder: (BuildContext context, UserApp currentUser, Widget child) {
        // if (model.state == ViewState.Busy) return _showLoadIndicator;
        if (currentUser != null) {
          debugPrint("=========>${currentUser.onBoardCompleted}");
          if (currentUser.onBoardCompleted == null ||
              !currentUser.onBoardCompleted) return OnBoardingScreen();
          return child;
        } else {
          return _showLoadIndicator;
          // return LoginScreen();
        }
      },
    );
  }
}
