import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:login_register/utlities/app_colors.dart';

class IntroWidget extends StatelessWidget {
  const IntroWidget({
    Key? key,
    required this.screenWidth,
    required this.screenheight,
    this.image,
    this.type,
    required this.startGradientColor,
    required this.endGradientColor,
    required this.subText,
  }) : super(key: key);

  final double screenWidth;
  final double screenheight;
  final image;
  final type;
  final Color startGradientColor;
  final Color endGradientColor;
  final String subText;

  @override
  Widget build(BuildContext context) {
    final Shader linearGradient = LinearGradient(
      colors: <Color>[startGradientColor, endGradientColor],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    return Container(
      padding: EdgeInsets.only(top: 25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            startGradientColor,
            endGradientColor,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          Center(
            child: Text(
              type.toString(),
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  // foreground: Paint()..shader = linearGradient,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
          Center(
            child: Image.asset(
              image,
              width: screenWidth / 1.3,
              // height: screenheight * 0.3,
              fit: BoxFit.contain,
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: Text(
              subText,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 18
                    // shadows: <Shadow>[
                    //   Shadow(
                    //     offset: Offset(4, 4),
                    //     blurRadius: 10,
                    //     color: startGradientColor,
                    //   ),
                    //   Shadow(
                    //     offset: Offset(4, 4),
                    //     blurRadius: 10,
                    //     color: startGradientColor,
                    //   ),
                    // ],
                    ),
              ),
            ),
          ),
          Spacer(),
          Spacer(),
        ],
      ),
    );
  }
}
