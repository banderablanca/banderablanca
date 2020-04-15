import 'package:banderablanca/constants/app_constants.dart';
import 'package:banderablanca/core/core.dart';
import 'package:banderablanca/ui/shared/shared.dart';
import 'package:flutter/material.dart';
// import 'package:login_register/utlities/app_colors.dart';

import 'intro_widget.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  double screenWidth = 0.0;
  double screenheight = 0.0;

  int currentPageValue = 0;
  int previousPageValue = 0;
  PageController controller;
  double _moveBar = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = PageController(initialPage: currentPageValue);
  }

  void getChangedPageAndMoveBar(int page) {
    debugPrint('page is $page');
    currentPageValue = page;
    setState(() {});

    if (previousPageValue == 0) {
      previousPageValue = page;
      _moveBar = _moveBar + 0.14;
    } else {
      if (previousPageValue < page) {
        previousPageValue = page;
        _moveBar = _moveBar + 0.14;
      } else {
        previousPageValue = page;
        _moveBar = _moveBar - 0.14;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;

    final List<Widget> introWidgetsList = <Widget>[
      IntroWidget(
          screenWidth: screenWidth,
          screenheight: screenheight,
          image: 'assets/onboard/map.png',
          type: 'Alzar una bandera',
          startGradientColor: Color(0xFFFF98A5),
          endGradientColor: Colors.white,
          subText:
              'Registra los datos y direción de la familia que necesita Apoyo'),
      IntroWidget(
          screenWidth: screenWidth,
          screenheight: screenheight,
          image: 'assets/onboard/go_help.png',
          type: '¿Quieres ayudar?',
          startGradientColor: Color(0xFFADBBFF),
          endGradientColor: Colors.white,
          subText:
              'Visualiza en el mapa que hogares necesitan ayuda por tu zona'),
      IntroWidget(
          screenWidth: screenWidth,
          screenheight: screenheight,
          image: 'assets/onboard/family.png',
          type: 'Es tiempo de ayudarnos',
          startGradientColor: Color(0xFFFF98A5),
          endGradientColor: Colors.white,
          subText:
              "Si quieres apoyar a algún  caso, deja un comentario o publica una foto del apoyo brindado"),
    ];

    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            PageView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: introWidgetsList.length,
              onPageChanged: (int page) {
                getChangedPageAndMoveBar(page);
              },
              controller: controller,
              itemBuilder: (context, index) {
                return introWidgetsList[index];
              },
            ),
            Stack(
              alignment: AlignmentDirectional.topStart,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 35),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (var i in introWidgetsList) slidingBar(),
                    ],
                  ),
                ),
                AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    curve: Curves.fastOutSlowIn,
                    margin: EdgeInsets.only(
                        bottom: 35, left: screenWidth * _moveBar),
                    //left: screenWidth * _moveBar,
                    child: movingBar()),
              ],
            ),
            Positioned(
              bottom: 50,
              right: 10,
              child: Visibility(
                visible: currentPageValue == introWidgetsList.length - 1
                    ? true
                    : false,
                child: FloatingActionButton(
                  onPressed: () async {
                    Provider.of<UserModel>(context, listen: false)
                        .onBoardCompleted();
                    // Navigator.of(context).pushReplacementNamed(RoutePaths.Home);
                  },
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(26))),
                  child: Icon(Icons.arrow_forward),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Container movingBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: 5,
      width: screenWidth * 0.1,
      decoration: BoxDecoration(color: Color(0XFFd8d8d8)),
    );
  }

  Widget slidingBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: 5,
      width: screenWidth * 0.1,
      decoration: BoxDecoration(color: Color(0XFF313543)),
    );
  }
}
