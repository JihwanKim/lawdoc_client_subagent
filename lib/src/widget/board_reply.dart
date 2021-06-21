import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/model/board_item.dart';
import 'package:subagent/src/model/reply_item.dart';
import 'package:subagent/src/page/board_reply_edit_page.dart';
import 'package:subagent/src/provider/reply_provider.dart';
import 'package:subagent/src/utils/utils.dart';
import 'package:subagent/src/widget/subagent_dialog.dart';

class BoardReply extends StatefulWidget {
  final BoardItem boardItem;
  final ReplyItem replyItem;

  const BoardReply({Key key, this.boardItem, this.replyItem}) : super(key: key);
  @override
  _BoardReplyState createState() => _BoardReplyState();
}

class _BoardReplyState extends State<BoardReply> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: buildNickName()),
                buildEditAndReportButton(),
                buildWriteDateTime(),
              ],
            ),
            Row(
              children: [
                Expanded(child: Text("${widget.replyItem.content}")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditAndReportButton() {
    final prov = Provider.of<ReplyProvider>(context, listen: false);
    return Row(
      children: [
        if (widget.replyItem.isMyReply)
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => BoardReplyEditPage(
                      boardItem: widget.boardItem,
                      replyItem: widget.replyItem,
                    ),
                  ),
                );
              }),
        if (widget.replyItem.isMyReply)
          IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                prov.remove(
                    widget.boardItem.idx,
                    widget.replyItem);
              }),
        IconButton(
          icon: Icon(Icons.report),
          onPressed: () async {
            final dialogResponse = await showDialog(
              context: context,
              builder: (BuildContext dialogContext) => SubAgentDialog(
                title: "댓글을 신고하시겠습니까?",
                okButtonContent: "신고",
                cancelButtonContent: "취소",
                onOkButtonClick: () async {
                  final replyProvider =
                      Provider.of<ReplyProvider>(context, listen: false);
                  await replyProvider.report(widget.replyItem);
                },
              ),
            );
            if(dialogResponse == DialogResponse.OK){
              Utils.showSnackBar("댓글 신고가 접수되었습니다.", context, 1);
            }
          },
        ),
      ],
    );
  }

  Widget buildNickName() => widget.replyItem.isAnonymous
      ? Text("익명")
      : Text("${widget.replyItem.writerUserNick}");

  Widget buildWriteDateTime() =>
      Text(widget.replyItem.createDateTime.toString().substring(0, 16));
}
