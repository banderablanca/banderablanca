import 'dart:io';

import 'package:banderablanca/core/core.dart';
import 'package:banderablanca/ui/shared/shared.dart';
import 'package:banderablanca/ui/views/home/photo_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'video_player_screen.dart';

class CommentsList extends StatefulWidget {
  const CommentsList({Key key, @required this.flag}) : super(key: key);

  final WhiteFlag flag;

  @override
  _CommentsListState createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  WhiteFlag get flag => widget.flag;

  @override
  void initState() {
    Provider.of<MessageModel>(context, listen: false)
        .fetchMessages(widget.flag.id);
    super.initState();
  }

  _previewMedia() {
    if (!flag.mediaContent.mimeType.startsWith('video/')) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => PhotoViewScreen(
            photoUrl: flag.photoUrl,
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => VideoPlayerScreen(
            filePath: flag.mediaContent.downloadUrl,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Selector<MessageModel, List<Message>>(
        selector: (_, MessageModel model) => model.messages,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Divider(),
            ListTile(
              dense: true,
              title: Text(
                "Bandera blanca",
                style: Theme.of(context).textTheme.subhead.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontFamily: "Tajawal Bold"),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text("${flag.description}"),
                ),
                InkWell(
                  onTap: _previewMedia,
                  child: _previewImage(),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(),
            ListTile(
              dense: true,
              title: Text(
                "Comentarios",
                style: Theme.of(context).textTheme.subhead.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontFamily: "Tajawal Bold"),
              ),
            ),
          ],
        ),
        builder: (BuildContext context, List<Message> messages, Widget child) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: messages.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) return child;
              final Message message = messages[index - 1];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Container(
                    width: 40,
                    height: 40,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  title: Text("${message.senderName ?? 'Anónimo'}"),
                  subtitle: Text("${message.text}"),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _previewImage() {
    return Stack(
      children: <Widget>[
        Container(
          height: 100,
          width: 100,
          margin: EdgeInsets.all(14),
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).primaryColor, width: 2)),
          child: TransitionToImage(
            image: AdvancedNetworkImage(
              "${flag.mediaContent?.downloadUrl}",
              loadedCallback: () {
                print('It works!');
              },
              loadFailedCallback: () {
                print('Oh, no!');
              },
              loadingProgress: (double progress, _) {
                // print('Now Loading: $progress');
              },
            ),
            loadingWidgetBuilder: (_, double progress, __) => Center(
              child: CircularProgressIndicator(
                value: progress,
              ),
            ),
            fit: BoxFit.cover,
            width: double.infinity,
            alignment: Alignment.center,
            placeholder: const Icon(Icons.refresh),
            enableRefresh: true,
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
                      .title
                      .copyWith(color: Theme.of(context).accentColor),
                ),
              ]),
        )),
      ],
    );
  }
}
