import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subagent/src/model/subagent_item.dart';
import 'package:subagent/src/view/subagent_detail_view.dart';
import 'package:subagent/src/view/subagent_write_view.dart';

class SubagentDetailPage extends StatefulWidget {
  final SubAgentItem subAgentItem;

  const SubagentDetailPage({Key key, this.subAgentItem}) : super(key: key);

  @override
  _SubagentDetailPageState createState() => _SubagentDetailPageState();
}

class _SubagentDetailPageState extends State<SubagentDetailPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SubagentDetailView(subAgentItem: widget.subAgentItem),
    ));
  }
}
