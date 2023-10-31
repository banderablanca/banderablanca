import 'package:banderablanca/core/core.dart';
import 'package:banderablanca/core/models/models.dart';
import 'package:banderablanca/ui/helpers/show_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'show_modal_bottom.dart';

class TabMyFlags extends StatelessWidget {
  const TabMyFlags({Key? key, required this.destination}) : super(key: key);
  final Destination destination;

  _showConfirmDialog(context, WhiteFlag flag) async {
    bool isConfirm = await showConfirmDialog(context,
        title: "¿Deseas eliminar bandera?",
        content:
            "Si eliminas la Bandera Blanca, dejará de mostrarse en el mapa.",
        confirmText: "ELIMINAR");
    if (isConfirm) {
      await Provider.of<FlagModel>(context, listen: false).deleteFlag(flag);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Selector<FlagModel, List<WhiteFlag>>(
        selector: (_, FlagModel model) => model.flags
            .where((t) => t.uid == context.read<UserModel>().currentUser!.id)
            .toList(),
        builder: (BuildContext context, List<WhiteFlag> list, _) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 64, bottom: 16),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    Positioned(
                        left: -15,
                        bottom: -16,
                        child: Opacity(
                          opacity: 0.10,
                          child: Image.asset(
                            "assets/img/localization.png",
                            width: 80,
                          ),
                        )),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        "Mis banderas",
                        style: GoogleFonts.tajawal(
                          textStyle: Theme.of(context)
                              .textTheme
                              .headline5!
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
                            text:
                                "Aquí podrás ver tus banderas registradas\n\n",
                            style: GoogleFonts.lato(
                              textStyle: Theme.of(context).textTheme.titleLarge,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "Si ves un hogar con bandera blanca por favor brinda tu apoyo y/o registra una Bandera para que otras personas puedan ir en su apoyo.",
                                style: GoogleFonts.lato(
                                  textStyle:
                                      Theme.of(context).textTheme.bodySmall,
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
                      final WhiteFlag flag = list[index];
                      return Container(
                        margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: Offset(
                                2.0,
                                2.0,
                              ),
                            )
                          ],
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            child: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).primaryColorLight,
                              child: Icon(
                                Icons.flag,
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                          ),
                          title: Text("${flag.address}"),
                          onTap: () {
                            showModalBottomFlagDetail(context, flag);
                          },
                          trailing: context.read<UserModel>().currentUser!.id !=
                                  flag.uid
                              ? SizedBox()
                              : IconButton(
                                  icon: Icon(Icons.delete_outline,
                                      color: Colors.red),
                                  onPressed: () {
                                    _showConfirmDialog(context, flag);
                                  }),
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
