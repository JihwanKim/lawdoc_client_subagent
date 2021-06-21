import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/provider/court_provider.dart';
import 'package:subagent/src/provider/subagent_provider.dart';
import 'package:subagent/src/widget/subagent_simple.dart';

class SubagentList extends StatefulWidget {
  @override
  _SubagentListState createState() => _SubagentListState();
}

class _SubagentListState extends State<SubagentList> {
  bool _isLoad = false;

  Future firstLoad() async {
    final prov = Provider.of<SubAgentProvider>(context, listen: false);
    _isLoad = true;
    await Future.delayed(Duration(seconds: 1));
    await prov.loadNormal();
    _isLoad = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstLoad();
  }

  @override
  Widget build(BuildContext context) {
    final subAgentProv = Provider.of<SubAgentProvider>(context);
    final courtProv = Provider.of<CourtProvider>(context, listen: false);
    if (_isLoad) {
      return Center(
        child: Container(
            width: 50, height: 50, child: CupertinoActivityIndicator()),
      );
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          await subAgentProv.loadNormal(
              locations: courtProv.filterItems);
        },
        child: ListView.builder(
          itemCount: subAgentProv.subAgentList.length,
          itemBuilder: (context, index) {
            return SubagentSimple(
                subAgentItem: subAgentProv.subAgentList[index]);
          },
        ),
      );
    }
  }
}
