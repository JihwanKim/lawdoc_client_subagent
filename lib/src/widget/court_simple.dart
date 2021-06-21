
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/model/court_item.dart';
import 'package:subagent/src/provider/court_provider.dart';

class CourtSimple extends StatefulWidget {
  final CourtItem court;
  @override
  const CourtSimple({Key key, this.court}) : super(key: key);
  _CourtSimpleState createState() => _CourtSimpleState();
}

class _CourtSimpleState extends State<CourtSimple> {

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CourtProvider>(context, listen: false);
    return Row(
      children: [
        Checkbox(
            value: widget.court.isFilter,
            onChanged: (value) {
              if (value) {
                prov.addFilter(widget.court);
              } else {
                prov.removeFilter(widget.court);
              }
              setState(() {
                widget.court.isFilter = value;
              });
            }),
        Container(
          child: Text(widget.court.name),
        ),
      ],
    );
  }
}
