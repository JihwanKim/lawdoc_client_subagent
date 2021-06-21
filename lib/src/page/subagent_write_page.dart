import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subagent/src/model/subagent_item.dart';
import 'package:subagent/src/view/subagent_write_view.dart';

class SubagentWritePage extends StatefulWidget {
  final SubAgentItem subAgentItem;

  const SubagentWritePage({Key key, this.subAgentItem}) : super(key: key);

  @override
  _SubagentWritePageState createState() => _SubagentWritePageState();
}

class _SubagentWritePageState extends State<SubagentWritePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SubagentWriteView(subAgentItem: widget.subAgentItem),
    ));
  }
}
