import 'package:banderablanca/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    Key key,
    @required this.flag,
    @required this.active,
    @required this.onTap,
  }) : super(key: key);

  final WhiteFlag flag;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double blur = active ? 30 : 0;
    final double offset = active ? 10 : 0;
    final double top = active ? 8 : 16;
    final double elevation = active ? 6 : 2;

    // final WhiteFlag flag = flags[currentIdx];
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
      margin: EdgeInsets.only(top: top, right: 30),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
        // BoxShadow(
        //   color: Colors.black12,
        //   blurRadius: blur,
        //   offset: Offset(offset, offset),
        // )
      ]),
      child: Center(
        child: Card(
            elevation: elevation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: flag.photoUrl != null
                        ? AdvancedNetworkImage(
                            "${flag.photoUrl}",
                            useDiskCache: true,
                            cacheRule:
                                CacheRule(maxAge: const Duration(days: 7)),
                          )
                        : null,
                    child: flag.photoUrl == null
                        ? Icon(FontAwesomeIcons.flag)
                        : Container(),
                  ),
                  title: Text(
                    '${flag?.address}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${flag?.description}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: const Text('VER'),
                      onPressed: onTap,
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
