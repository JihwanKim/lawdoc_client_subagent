import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/provider/board_provider.dart';
import 'package:subagent/src/widget/board_simple.dart';

class BoardList extends StatefulWidget {
  final BoardType boardType;

  const BoardList({Key key, this.boardType}) : super(key: key);
  @override
  _BoardListState createState() => _BoardListState();
}

class _BoardListState extends State<BoardList> {
  bool _isLoad = false;

  _loadMore() async {
    final boardProv = Provider.of<BoardProvider>(context, listen: false);
    setState(() {
      _isLoad = true;
    });
    await boardProv.loadMore(widget.boardType, boardProv.list.last.idx);
    setState(() {
      _isLoad = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<BoardProvider>(context);
    final double width = MediaQuery.of(context).size.width;
    if (prov.isLoad) {
      return Center(
        child: Container(
            width: 50, height: 50, child: CupertinoActivityIndicator()),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(8.0),
        child: Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels != 0.0 &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  if (_isLoad) return true;
                  _loadMore();
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  await prov.load(widget.boardType);
                },
                child: ListView.builder(
                  // controller: _scrollController,

                  itemCount: prov.list.length,
                  itemBuilder: (context, index) {
                    return BoardSimple(boardItem: prov.list[index]);
                  },
                ),
              ),
            ),
            if (_isLoad)
              Positioned(
                  left: width / 2 - 15,
                  bottom: 30,
                  child: Container(
                      width: 30,
                      height: 30,
                      child: CupertinoActivityIndicator())),
          ],
        ),
      );
    }
  }
}
