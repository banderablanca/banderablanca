import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import 'onboard/onboard_screen.dart';
import 'views.dart';
import 'widgets/widgets.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      initialData: null,
      value: FirebaseAuth.instance.authStateChanges(),
      updateShouldNotify: (User? previous, User? current) =>
          previous != current,
      child: RedirectionWidget(),
    );
  }
}

class RedirectionWidget extends StatelessWidget {
  Widget get _showLoadIndicator => Scaffold(body: SplashLoading());
  @override
  Widget build(BuildContext context) {
    // print(context.read<UserModel>().currentUser ?? '');
    // return _showLoadIndicator;
    return Selector<UserModel, UserApp?>(
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
      builder: (BuildContext context, UserApp? currentUser, Widget? child) {
        // if (model.state == ViewState.Busy) return _showLoadIndicator;
        if (currentUser != null) {
          if (!currentUser.onBoardCompleted) return OnBoardingScreen();
          return child!;
        } else {
          return _showLoadIndicator;
          // return LoginScreen();
        }
      },
    );
  }
}
