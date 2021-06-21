import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subagent/src/view/court_filter_view.dart';

class CourtFilterPage extends StatefulWidget {
  @override
  _CourtFilterPageState createState() => _CourtFilterPageState();
}

class _CourtFilterPageState extends State<CourtFilterPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: CourtFilterView(),
    ));
  }
}
