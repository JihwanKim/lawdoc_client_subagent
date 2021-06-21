import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subagent/src/model/board_item.dart';
import 'package:subagent/src/provider/board_provider.dart';
import 'package:subagent/src/view/board_new_or_edit_view.dart';

class BoardNewOrEditPage extends StatefulWidget {
  final BoardItem boardItem;
  final BoardType boardType;

  const BoardNewOrEditPage({Key key, this.boardType, this.boardItem}) : super(key: key);
  @override
  _BoardNewOrEditPageState createState() => _BoardNewOrEditPageState();
}

class _BoardNewOrEditPageState extends State<BoardNewOrEditPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BoardNewOrEditView(boardType: widget.boardType, boardItem: widget.boardItem,),
      ),
    );
  }
}
