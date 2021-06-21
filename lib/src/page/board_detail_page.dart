import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subagent/src/model/board_item.dart';
import 'package:subagent/src/view/board_detail_view.dart';

class BoardDetailPage extends StatelessWidget {
  final BoardItem boardItem;

  const BoardDetailPage({Key key, this.boardItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: BoardDetailView(boardItem:boardItem),
    ),);
  }
}
