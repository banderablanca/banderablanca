import 'package:banderablanca/core/core.dart';
import 'package:banderablanca/ui/helpers/show_confirm_dialog.dart';
import 'package:banderablanca/ui/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'comments_list.dart';

showModalBottomFlagDetail(context, WhiteFlag flag) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: FractionallySizedBox(
              heightFactor: 0.8,
              child: Container(
                // color: Colors.grey[900],
                // height: 250,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "${flag.address}",
                        style: GoogleFonts.tajawal(),
                      ),
                      trailing: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.chevronDown,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                    CommentsList(flag: flag),
                    if (Provider.of<UserModel>(context).currentUser.id !=
                        flag.uid)
                      InkWell(
                        onTap: () => _showConfirmDialog(context, flag),
                        child: Container(
                          width: double.infinity,
                          height: 30,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.report,
                                color: Colors.red,
                                size: 12,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Reportar bandera",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SendMessageTextField(
                      flag: flag,
                    ),
                  ],
                ),
              ),
            ),
          ));
}

_showConfirmDialog(context, WhiteFlag flag) async {
  bool isConfirm = await showConfirmDialog(context,
      title: "Reportar bandera falsa",
      content:
          "Reporta si la bandera blanca es falsa, si obtiene muchos reportes será elimnado del mapa.",
      confirmText: "REPORTAR");
  if (isConfirm)
    Provider.of<FlagModel>(context, listen: false).reportFlag(flag);
}
