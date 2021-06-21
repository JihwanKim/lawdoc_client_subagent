import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subagent/src/model/subagent_item.dart';
import 'package:subagent/src/page/subagent_history_detail_page.dart';

class SubAgentHistory extends StatelessWidget {
  final SubAgentItem subAgentItem;

  const SubAgentHistory({Key key, this.subAgentItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SubAgentHistoryDetailPage(
              subAgentItem: subAgentItem,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0),
        child: Card(
          child: Container(
            padding: EdgeInsets.all(4.0),
            child: Row(
              children: [
                Icon(Icons.notifications),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("복대리 제목"),
                      Text("복대리 고객"),
                      Text("복대리 금액"),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Text("복대리 의뢰/수임"),
                    Text("${DateTime.now().toString().substring(0, 16)}"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
