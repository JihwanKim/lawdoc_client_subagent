import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subagent/src/model/board_item.dart';
import 'package:subagent/src/model/reply_item.dart';
import 'package:subagent/src/view/board_reply_edit_view.dart';

class BoardReplyEditPage extends StatefulWidget {
  final ReplyItem replyItem;
  final BoardItem boardItem;

  const BoardReplyEditPage({Key key, this.boardItem, this.replyItem}) : super(key: key);
  @override
  _BoardReplyEditPageState createState() => _BoardReplyEditPageState();
}

class _BoardReplyEditPageState extends State<BoardReplyEditPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BoardReplyEditView(
          boardItem: widget.boardItem,
          replyItem: widget.replyItem,
        ),
      ),
    );
  }
}
