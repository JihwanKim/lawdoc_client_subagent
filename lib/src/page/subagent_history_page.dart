import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subagent/src/view/subagent_history_view.dart';

class SubAgentHistoryPage extends StatefulWidget {
  @override
  _SubAgentHistoryPageState createState() => _SubAgentHistoryPageState();
}

class _SubAgentHistoryPageState extends State<SubAgentHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SubAgentHistoryView(),
      ),
    );
  }
}
