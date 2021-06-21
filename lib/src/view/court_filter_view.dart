
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/provider/court_provider.dart';
import 'package:subagent/src/utils/ui.dart';
import 'package:subagent/src/widget/court_simple.dart';

class CourtFilterView extends StatefulWidget {
  @override
  _CourtFilterViewState createState() => _CourtFilterViewState();
}

class _CourtFilterViewState extends State<CourtFilterView> {
  TextEditingController _searchController;

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

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
                labelText: "검색",
                labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
                suffix: GestureDetector(
                  child: Icon(Icons.close),
                  onTap: () {
                    setState(() {
                      _searchController.text = "";
                    });
                  },
                ),
              ),
              onChanged: (text) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    final prov = Provider.of<CourtProvider>(context);
    final list = prov.courtList(filterStr: _searchController.text);
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return CourtSimple(court: list[index]);
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBar(),
        _buildSearchBar(),
        Expanded(
            child:
            Container(padding: EdgeInsets.all(8.0), child: _buildList())),
      ],
    );
  }
}
