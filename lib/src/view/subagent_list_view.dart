import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/page/court_filter_page.dart';
import 'package:subagent/src/page/subagent_write_page.dart';
import 'package:subagent/src/provider/court_provider.dart';
import 'package:subagent/src/provider/subagent_provider.dart';
import 'package:subagent/src/widget/subagent_list.dart';

class SubagentListView extends StatefulWidget {
  @override
  _SubagentListViewState createState() => _SubagentListViewState();
}

class _SubagentListViewState extends State<SubagentListView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final courtProv = Provider.of<CourtProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    icon: Icon(
                        courtProv.isHasFilter?
                        Icons.filter_alt
                        : Icons.filter_alt_outlined
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => CourtFilterPage(),
                        ),
                      );
                    }),
                IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
              ],
            ),
          ),
          Expanded(
            child: SubagentList(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //복대리 구함 작성 페이지로 이동
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SubagentWritePage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
