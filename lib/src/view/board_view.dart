import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/model/user_info.dart';
import 'package:subagent/src/page/board_new_or_edit_page.dart';
import 'package:subagent/src/provider/board_provider.dart';
import 'package:subagent/src/provider/user_provider.dart';
import 'package:subagent/src/utils/ui.dart';
import 'package:subagent/src/widget/board_list.dart';

class BoardView extends StatefulWidget {
  @override
  _BoardViewState createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  BoardType boardValue = BoardType.ALL;
  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: DropdownButtonFormField<BoardType>(
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                    items: [
                      DropdownMenuItem(
                        child: Text("전체 게시판"),
                        value: BoardType.ALL,
                      ),
                      DropdownMenuItem(
                        child: Text("전체 Q&A"),
                        value: BoardType.ALL_QA,
                      ),
                      if (userProv.userInfo.type == UserType.LAWYER)
                        DropdownMenuItem(
                          child: Text("변호사전용 게시판"),
                          value: BoardType.LAWYER,
                        ),
                      if (userProv.userInfo.type == UserType.LAWYER)
                        DropdownMenuItem(
                          child: Text(
                            "변호사전용 Q&A",
                          ),
                          value: BoardType.LAWYER_QA,
                        ),
                    ],
                    onChanged: (item) {
                      if(boardValue == item){
                        return;
                      }

                      boardValue = item;
                      final prov =
                          Provider.of<BoardProvider>(context, listen: false);
                      prov.load(item);
                      setState(() {});
                    },
                    value: boardValue,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                  },
                ),
              ],
            ),
          ),
          Expanded(child: BoardList(boardType: boardValue))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //복대리 구함 작성 페이지로 이동
          // write new board
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) =>
                  BoardNewOrEditPage(boardType: boardValue),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
