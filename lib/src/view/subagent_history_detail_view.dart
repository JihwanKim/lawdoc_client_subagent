import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subagent/src/model/subagent_item.dart';

class SubAgentHistoryDetailView extends StatefulWidget {
  final SubAgentItem subAgentItem;

  const SubAgentHistoryDetailView({Key key, this.subAgentItem})
      : super(key: key);
  @override
  _SubAgentHistoryDetailViewState createState() =>
      _SubAgentHistoryDetailViewState();
}

class _SubAgentHistoryDetailViewState extends State<SubAgentHistoryDetailView> {
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("복대리 제목"),
                Text("복대리 고객"),
                Text("복대리 금액"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
