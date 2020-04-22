
import 'package:banderablanca/core/core.dart';
import 'package:banderablanca/core/models/models.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'show_modal_bottom.dart';

class TabNotifications extends StatelessWidget {
  const TabNotifications({Key key, this.destination}) : super(key: key);

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Selector<NotificationModel, List<UserNotification>>(
        selector: (_, NotificationModel model) => model.notifications,
        builder:
            (BuildContext context, List<UserNotification> list, Widget child) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 64, bottom: 16),
                child: Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    Positioned(
                        left: -15,
                        bottom: -16,
                        child: Opacity(
                          opacity: 0.10,
                          child: Image.asset(
                            "assets/img/notifications.png",
                            width: 80,
                          ),
                        )),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        "Notificaciones",
                        style: GoogleFonts.tajawal(
                          textStyle: Theme.of(context)
                              .textTheme
                              .headline
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              if (list.isEmpty)
                Flexible(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: "Aún no tienes notificaciones.\n\n",
                            style: GoogleFonts.lato(
                              textStyle: Theme.of(context).textTheme.title,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "Aquí podrás ver interacciones sobre un hogar con bandera blanca que reportaste y/o comentaste.",
                                style: GoogleFonts.lato(
                                  textStyle:
                                      Theme.of(context).textTheme.caption,
                                ),
                              )
                            ]),
                      ),
                    ),
                  ),
                ),
              if (list.isNotEmpty)
                Flexible(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      final UserNotification notification = list[index];
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            child: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).primaryColorLight,
                              child: Icon(
                                FontAwesomeIcons.commentDots,
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                          ),
                          title: Text("${notification.message}"),
                          onTap: () {
                            var flag =
                                Provider.of<FlagModel>(context, listen: false)
                                    .getFlagById(notification.flagId);
                            if (flag != null)
                              showModalBottomFlagDetail(context, flag);
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
