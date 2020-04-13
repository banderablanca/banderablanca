import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../shared/keys.dart';

class SplashLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            child: SvgPicture.asset(
              "assets/img/trama.svg",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            //    alignment: Alignment.center,
            children: <Widget>[
              Hero(
                tag: AppKeys.logo,
                // child: FlutterLogo(),
                child: Icon(
                  FontAwesomeIcons.fontAwesomeFlag,
                  size: 70,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Text(
                "Bandera",
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(fontFamily: "Tajawal Light", color: Colors.white),
              ),
              Text(
                "Blanca",
                style: Theme.of(context)
                    .textTheme
                    .display2
                    .copyWith(fontFamily: "Tajawal Bold", color: Colors.white),
              )
            ],
          )
        ],
      ),
    );
  }
}
