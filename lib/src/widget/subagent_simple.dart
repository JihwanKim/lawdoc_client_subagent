import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subagent/src/model/subagent_item.dart';
import 'package:subagent/src/page/subagent_detail_page.dart';
import 'package:subagent/src/utils/convert_util.dart';
import 'package:subagent/src/utils/ui.dart';

class SubagentSimple extends StatelessWidget {
  final SubAgentItem subAgentItem;

  const SubagentSimple({Key key, this.subAgentItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Column(children: [
            Text('${ConvertUtil.parseDate(subAgentItem.subAgentAt.toString())}',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
            Text('${ConvertUtil.parseTime(subAgentItem.subAgentAt.toString())}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
            Text(
              '${ConvertUtil.parseAmOrPm(subAgentItem.subAgentAt.toString())}',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
          ]),
          title: Text(
            '${subAgentItem.title}',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: UI
                    .TEXT_BLACK_COLOR),
          ),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(
                '${subAgentItem.place}',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: UI.TEXT_DEFAULT_COLOR),
              )),
              Text(
                '${ConvertUtil.parsePrice(subAgentItem.pay)}원',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: UI.TEXT_DEFAULT_COLOR),
              )
            ],
            mainAxisSize: MainAxisSize.max,
          ),
          trailing: Icon(Icons.arrow_right),
          onTap: () {
            //복대리 구함 상세 페이지로 이동
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SubagentDetailPage(subAgentItem: subAgentItem)));
          },
        ),
        Divider(
          indent: 10.0,
          endIndent: 10.0,
        )
      ],
    );
  }
}
