import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subagent/src/model/board_item.dart';
import 'package:subagent/src/page/board_detail_page.dart';
import 'package:subagent/src/utils/ui.dart';

class BoardSimple extends StatelessWidget {
  final BoardItem boardItem;

  const BoardSimple({Key key, this.boardItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => BoardDetailPage(
              boardItem: boardItem,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(8, 8, 4, 8),
                    child: Text(
                      "${boardItem.title}",
                      overflow: TextOverflow.clip,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: UI.TEXT_BLACK_COLOR),
                    ),
                  ),
                ),
                Text(
                  "${boardItem.createDateTime.toString().substring(11, 16)}",
                  style: TextStyle(color: UI.TEXT_DEFAULT_COLOR),
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
