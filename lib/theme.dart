import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static get theme {
    return ThemeData(
      primaryColor: Color(0xFF6870FB),
      primaryColorLight: Color(0xFFD2DAFD),
      primaryColorDark: Color(0xFF202468),
      // secondaryHeaderColor: Color(0xFF06F482),
      accentColor: Color(0xFFFF5D71),
      // fontFamily: "Tajawal",
      // fontFamily: GoogleFonts.tajawalTextTheme(),
      textTheme: GoogleFonts.tajawalTextTheme(
          // Theme.of(context).textTheme,
          ),
      iconTheme: IconThemeData(
        color: Colors.grey[700],
      ),
      backgroundColor: Color(0xFFF3F6FF),
      bottomAppBarColor: Colors.grey[800],
      scaffoldBackgroundColor: Colors.white,
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
      ),
    );

    // final originalTextTheme = ThemeData.light().textTheme;
    // final originalBody1 = originalTextTheme.body1;

    // return ThemeData.light().copyWith(
    //       primaryColor: Color(0xFF541A49),
    //       secondaryHeaderColor: Color(0xFF06F482),
    //       accentColor: Color(0xFFd4005e),
    //       iconTheme:  IconThemeData(
    //         color: Color(0xFFd4005e),
    //       ),
    //       // buttonColor: Colors.grey[800],
    //       // textSelectionColor: Colors.cyan[100],
    //       // backgroundColor: Colors.grey[800],
    //       // textTheme: originalTextTheme.copyWith(
    //       //     body1:
    //       //         originalBody1.copyWith(decorationColor: Colors.transparent))
    //     );
  }
}
