import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/model/board_item.dart';
import 'package:subagent/src/model/reply_item.dart';
import 'package:subagent/src/provider/reply_provider.dart';
import 'package:subagent/src/utils/ui.dart';

class BoardReplyEditView extends StatefulWidget {
  final BoardItem boardItem;
  final ReplyItem replyItem;

  const BoardReplyEditView({Key key, this.boardItem, this.replyItem}) : super(key: key);
  @override
  _BoardReplyEditViewState createState() => _BoardReplyEditViewState();
}

class _BoardReplyEditViewState extends State<BoardReplyEditView> {
  bool _isAnonymous;
  TextEditingController _editingController;
  Widget _buildTopTap() {
    return Container(
      height: 60,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _isAnonymousBuild() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
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
            style: TextStyle(fontSize: 22),
          ),
        ],
      ),
    );
  }

  Widget _contentBuild() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _editingController,
        minLines: 1,
        maxLines: 10,
        decoration: InputDecoration(
            labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(),
            labelText: "댓글"),
      ),
    );
  }

  Widget _saveButtonBuild() {
    return Row(
      children: [
        Expanded(
            child: Container(
                color: Colors.lightBlueAccent,
                child: FlatButton(
                    onPressed: () async {
                      final prov =
                          Provider.of<ReplyProvider>(context, listen: false);
                      await prov.save(
                        widget.boardItem.idx,
                          new ReplyItem(
                              widget.replyItem.idx,
                              _editingController.text,
                              widget.replyItem.writerUserNick,
                              widget.replyItem.isMyReply,
                              _isAnonymous,
                              widget.replyItem.createDateTime));
                      Navigator.pop(context);
                    },
                    child: Text("수정")))),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isAnonymous = widget.replyItem.isAnonymous;
    _editingController = TextEditingController(text: widget.replyItem.content);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTopTap(),
        Expanded(
          child: ListView(
            children: [
              _isAnonymousBuild(),
              _contentBuild(),
            ],
          ),
        ),
        _saveButtonBuild(),
      ],
    );
  }
}
