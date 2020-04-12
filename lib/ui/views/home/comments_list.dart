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
                "Ayudemos:",
                style: Theme.of(context).textTheme.subhead.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontFamily: "Tajawal Bold"),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text("${flag.description}"),
            ),
            !flag.mediaContent.mimeType.startsWith('video/')
                ? Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => PhotoViewScreen(
                              photoUrl: flag.photoUrl,
                            ),
                          ),
                        );
                      },
                      child: _previewImage(),
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    height: 200,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                VideoPlayerScreen(
                              filePath: flag.mediaContent.downloadUrl,
                            ),
                          ),
                        );
                      },
                      child: _previewImage(),
                    ),
                  ),
            SizedBox(
              height: 5,
            ),
            Divider(),
            ListTile(
              dense: true,
              title: Text(
                "Comentarios:",
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
              return ListTile(
                leading: CircleAvatar(),
                title: Text("${message.senderName ?? 'Anónimo'}"),
                subtitle: Text("${message.text}"),
              );
            },
          );
        },
      ),
    );
  }

  Widget _previewImage() {
    return SizedBox(
      height: 200,
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
        fit: BoxFit.contain,
        placeholder: const Icon(Icons.refresh),
        width: 400.0,
        height: 300.0,
        enableRefresh: true,
      ),
    );
  }
}
