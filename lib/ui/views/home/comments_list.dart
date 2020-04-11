import 'package:banderablanca/core/core.dart';
import 'package:banderablanca/ui/views/home/photo_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          children: <Widget>[
            Text("${flag.description}"),
            SizedBox(
              height: 200,
              width: 200,
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
                child: TransitionToImage(
                  image: AdvancedNetworkImage(
                    "${flag.photoUrl}",
                    loadedCallback: () {
                      print('It works!');
                    },
                    loadFailedCallback: () {
                      print('Oh, no!');
                    },
                    loadingProgress: (double progress, _) {
                      print('Now Loading: $progress');
                    },
                  ),
                  loadingWidgetBuilder: (_, double progress, __) => Center(
                    child: LinearProgressIndicator(
                      value: progress,
                    ),
                  ),
                  fit: BoxFit.contain,
                  placeholder: const Icon(Icons.refresh),
                  width: 400.0,
                  height: 300.0,
                  enableRefresh: true,
                ),
              ),
            ),
            Divider(),
            ListTile(
              title: Text("Comentarios"),
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
}
