import 'package:banderablanca/core/core.dart';
import 'package:banderablanca/ui/helpers/show_confirm_dialog.dart';
import 'package:banderablanca/ui/views/home/photo_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/shared.dart';
import 'video_player_screen.dart';

class CommentsList extends StatefulWidget {
  const CommentsList({
    Key? key,
    required this.flag,
  }) : super(key: key);

  final WhiteFlag flag;

  @override
  _CommentsListState createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  WhiteFlag get flag => widget.flag;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<MessageModel>(context, listen: false)
          .fetchMessages(widget.flag.id);
    });
    super.initState();
  }

  _previewMedia(String? url) {
    if (url == null) return;
    if (!flag.mediaContent!.mimeType!.startsWith('video/')) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => PhotoViewScreen(
            photoUrl: url,
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => VideoPlayerScreen(
            filePath: url,
          ),
        ),
      );
    }
  }

  _showConfirmDialog(WhiteFlag flag) async {
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

  _buildTrailingButton(WhiteFlag flag) {
    if (context.read<UserModel>().currentUser!.id != flag.uid)
      return Container(width: 0);
    return IconButton(
      icon: Provider.of<FlagModel>(context).state == ViewState.DeletingFlag
          ? Container(
              width: 29,
              height: 30,
              child: CircularProgressIndicator(),
            )
          : Icon(Icons.delete_outline, color: Colors.red),
      onPressed: () => _showConfirmDialog(flag),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Selector<MessageModel, List<Message>>(
        selector: (_, MessageModel model) => model.messages,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Divider(),
            ListTile(
              dense: true,
              title: Text("${flag.address}",
                  style: GoogleFonts.tajawal(
                    textStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  )),
              subtitle: Text(
                timeAgo(flag.timestamp ?? DateTime.now()),
                style: Theme.of(context).textTheme.caption,
              ),
              trailing: _buildTrailingButton(flag),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Text(
                        "${flag.description}",
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _previewMedia(flag.mediaContent!.downloadUrl),
                    child: _previewImage(
                        flag.mediaContent!.thumbnailInfo.downloadUrl, 100, 100),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(),
            ListTile(
              dense: true,
              title: Text(
                "Comentarios",
                style: GoogleFonts.tajawal(
                  textStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),
            ),
          ],
        ),
        builder: (BuildContext context, List<Message> messages, Widget? child) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: messages.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0 && child != null) return child;
              final Message message = messages[index - 1];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 18),
                // color:
                //     message.type == "help" ? Colors.blueAccent : Colors.transparent,
                child: ListTile(
                  onTap: () => _previewMedia(message.mediaContent!.downloadUrl),
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Container(
                    width: 40,
                    height: 40,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  title: Text(
                    "${message.senderName}",
                    style: GoogleFonts.tajawal(),
                  ),
                  subtitle: RichText(
                    text: TextSpan(
                      text: "${message.text}\n",
                      children: [
                        if (message.type == "help")
                          TextSpan(
                            text: "Ha donado para ${message.helpedDays} dīas ",
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                          ),
                        TextSpan(
                          text: "${timeAgo(flag.timestamp)}",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 10,
                              ),
                        )
                      ],
                      style: GoogleFonts.tajawal(
                        textStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  trailing: _previewImage(
                      message.mediaContent?.thumbnailInfo.downloadUrl ?? '',
                      50,
                      50),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _previewImage(String url, double height, double width) {
    if (url.isEmpty) return Container(width: 0);
    return Stack(
      children: <Widget>[
        Container(
          height: height,
          width: width,
          margin: EdgeInsets.all(14),
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).primaryColor, width: 2)),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            width: double.infinity,
            alignment: Alignment.center,
          ),
        ),
        Positioned.fill(
            child: Container(
          color: Colors.white.withOpacity(0.3),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.zoom_in, color: Theme.of(context).accentColor),
                SizedBox(width: 8),
                Text(
                  "Ver",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Theme.of(context).accentColor),
                ),
              ]),
        )),
      ],
    );
  }
}
