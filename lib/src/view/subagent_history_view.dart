import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subagent/src/widget/subagent_history.dart';

class SubAgentHistoryView extends StatefulWidget {
  @override
  _SubAgentHistoryViewState createState() => _SubAgentHistoryViewState();
}

class _SubAgentHistoryViewState extends State<SubAgentHistoryView> {
  Widget _buildAppBar() {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBar(),
        Expanded(
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return SubAgentHistory();
            },
          ),
        ),
      ],
    );
  }
}
