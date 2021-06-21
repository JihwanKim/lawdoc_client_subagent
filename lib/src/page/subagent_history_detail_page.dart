import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subagent/src/model/subagent_item.dart';
import 'package:subagent/src/view/subagent_history_detail_view.dart';

class SubAgentHistoryDetailPage extends StatefulWidget {
  final SubAgentItem subAgentItem;

  const SubAgentHistoryDetailPage({Key key, this.subAgentItem}) : super(key: key);
  @override
  _SubAgentHistoryDetailPageState createState() =>
      _SubAgentHistoryDetailPageState();
}

class _SubAgentHistoryDetailPageState extends State<SubAgentHistoryDetailPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SubAgentHistoryDetailView(subAgentItem:widget.subAgentItem),
      ),
    );
  }
}
