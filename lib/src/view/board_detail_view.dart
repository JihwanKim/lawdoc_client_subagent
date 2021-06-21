import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/model/board_item.dart';
import 'package:subagent/src/model/reply_item.dart';
import 'package:subagent/src/page/board_new_or_edit_page.dart';
import 'package:subagent/src/provider/board_provider.dart';
import 'package:subagent/src/provider/reply_provider.dart';
import 'package:subagent/src/provider/user_provider.dart';
import 'package:subagent/src/utils/ui.dart';
import 'package:subagent/src/utils/utils.dart';
import 'package:subagent/src/widget/board_image.dart';
import 'package:subagent/src/widget/board_reply.dart';
import 'package:subagent/src/widget/subagent_dialog.dart';

class BoardDetailView extends StatefulWidget {
  final BoardItem boardItem;

  const BoardDetailView({Key key, this.boardItem}) : super(key: key);
  @override
  _BoardDetailViewState createState() => _BoardDetailViewState();
}

class _BoardDetailViewState extends State<BoardDetailView> {
  BoardItem _boardItem;
  ScrollController _scrollController;

  Widget buildTopBar(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_boardItem.isMyBoard)
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      final responseBoardItem = await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => BoardNewOrEditPage(
                            boardItem: _boardItem,
                          ),
                        ),
                      );
                      if (responseBoardItem == null) {
                        return;
                      }
                      if (responseBoardItem is BoardItem) {
                        setState(() {
                          _boardItem = responseBoardItem;
                        });
                      }
                    }),
              if (_boardItem.isMyBoard)
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () async {
                    final response = await showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) => SubAgentDialog(
                        title: "게시글을 삭제하시겠습니까?",
                        okButtonContent: "삭제",
                        cancelButtonContent: "취소",
                        onOkButtonClick: () async {
                          final boardProvider = Provider.of<BoardProvider>(
                              context,
                              listen: false);
                          await boardProvider.remove(_boardItem);
                        },
                      ),
                    );
                    if (response == DialogResponse.OK) {
                      Navigator.pop(context);
                    }
                  },
                ),
              IconButton(
                icon: Icon(Icons.report_outlined),
                onPressed: () async {
                  final dialogResponse = await showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) => SubAgentDialog(
                      title: "게시글을 신고하시겠습니까?",
                      okButtonContent: "신고",
                      cancelButtonContent: "취소",
                      onOkButtonClick: () async {
                        final boardProvider =
                            Provider.of<BoardProvider>(context, listen: false);
                        await boardProvider.report(_boardItem);
                      },
                    ),
                  );
                  if (dialogResponse == DialogResponse.OK) {
                    Utils.showSnackBar("게시글 신고가 접수되었습니다.", context, 1);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Card buildImages() {
    return Card(
      child: Column(
        children: _boardItem.images
            .map(
              (e) => BoardImage(
                path: e,
              ),
            )
            .toList(),
      ),
    );
  }

  Expanded buildBody() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${_boardItem.title}",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    Text(
                        "${_boardItem.isAnonymous ? "익명" : _boardItem.writerUserNick}"),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        "${_boardItem.createDateTime.toString().substring(0, 16)}"),
                  ],
                ),
              ),
              Divider(),
              Text("${_boardItem.content}"),
              buildImages(),
              Divider(),
              ReplyList(
                boardItem: widget.boardItem,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _boardItem = widget.boardItem;
    final replyProv = Provider.of<ReplyProvider>(context, listen: false);
    replyProv.load(widget.boardItem.idx);
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTopBar(context),
        buildBody(),
        BoardReplyWrite(
            onSave: ()async{
              await Future.delayed(Duration(milliseconds: 500));
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
            },
            boardIdx: widget.boardItem.idx),
      ],
    );
  }
}

class BoardReplyWrite extends StatefulWidget {
  final int boardIdx;
  final Function onSave;

  const BoardReplyWrite({Key key, this.onSave, this.boardIdx}) : super(key: key);
  @override
  _BoardReplyWriteState createState() => _BoardReplyWriteState();
}

class _BoardReplyWriteState extends State<BoardReplyWrite> {
  bool _isAnonymous = true;
  TextEditingController _editingController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _editingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ReplyProvider>(context, listen: false);
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Checkbox(
                value: _isAnonymous,
                onChanged: (value) {
                  setState(() {
                    _isAnonymous = value;
                  });
                },
              ),
              Text(
                "익명",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _editingController,
                  minLines: 1,
                  maxLines: 10,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    labelText: "댓글",
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  final replyResult = await prov.save(
                      widget.boardIdx,
                      new ReplyItem(null, _editingController.text, "me", true,
                          _isAnonymous, DateTime.now()));
                  if (replyResult == null) {
                    final snackBar = SnackBar(
                      content: Text('댓글 저장에 실패하였습니다.'),
                      duration: Duration(seconds: 1),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                  } else {
                    widget.onSave();
                    setState(() {
                      _editingController.text = "";
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReplyList extends StatefulWidget {
  final BoardItem boardItem;

  const ReplyList({Key key, this.boardItem}) : super(key: key);
  @override
  _ReplyListState createState() => _ReplyListState();
}

class _ReplyListState extends State<ReplyList> {
  @override
  Widget build(BuildContext context) {
    final replyProv = Provider.of<ReplyProvider>(context);
    return Column(
      children: replyProv.list
          .map((e) => BoardReply(boardItem: widget.boardItem, replyItem: e))
          .toList(),
    );
  }
}
