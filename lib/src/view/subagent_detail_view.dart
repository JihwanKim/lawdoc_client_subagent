import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/model/subagent_item.dart';
import 'package:subagent/src/page/subagent_write_page.dart';
import 'package:subagent/src/provider/subagent_provider.dart';
import 'package:subagent/src/utils/convert_util.dart';
import 'package:subagent/src/utils/ui.dart';
import 'package:subagent/src/widget/subagent_dialog.dart';
import 'package:subagent/src/utils/utils.dart';

class SubagentDetailView extends StatefulWidget {
  final SubAgentItem subAgentItem;

  const SubagentDetailView({Key key, this.subAgentItem}) : super(key: key);

  @override
  _SubagentDetailViewState createState() => _SubagentDetailViewState();
}

class _SubagentDetailViewState extends State<SubagentDetailView> {
  TextEditingController _titleController;
  TextEditingController _contentController;
  TextEditingController _payController;
  TextEditingController _phoneController;
  TextEditingController _categoryController;
  TextEditingController _datetimeController;
  SubAgentItem _subAgentItem;
  int _value = 1;

  @override
  void initState() {
    super.initState();
    _subAgentItem = widget.subAgentItem;
    _titleController = TextEditingController(
        text: widget.subAgentItem != null ? _subAgentItem.title : "");
    _contentController = TextEditingController(
        text: widget.subAgentItem != null ? _subAgentItem.content : "");
    _payController = TextEditingController(
        text: widget.subAgentItem != null
            ? '${ConvertUtil.parsePrice(_subAgentItem.pay)}원'
            : "");
    _phoneController = TextEditingController(
        text: widget.subAgentItem != null ? _subAgentItem.phone : "");
    _categoryController = TextEditingController(
        text: widget.subAgentItem != null ? _subAgentItem.place : "");
    _datetimeController = TextEditingController(
        text: widget.subAgentItem != null
            ? '${ConvertUtil.parseDateTimeToString(_subAgentItem.subAgentAt)}'
            : "");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.all(10.0),
            height: 60,
            child: Row(
              children: [
                buildBack(context),
                Expanded(child: Text('')),
                DropdownButton(
                  underline: SizedBox(),
                  icon: Icon(Icons.more_vert),
                  items: <String>['수정하기', '삭제하기']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) async {
                    switch (value) {
                      case '수정하기':
                        final responseItem = await Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SubagentWritePage(
                              subAgentItem: _subAgentItem,
                            ),
                          ),
                        );
                        if (responseItem == null) {
                          return;
                        }
                        if (responseItem is SubAgentItem) {
                          setState(() {
                            _subAgentItem = responseItem;

                            _titleController.text = _subAgentItem.title;
                            _contentController.text = _subAgentItem.content;
                            _payController.text =
                                '${ConvertUtil.parsePrice(_subAgentItem.pay)}원';
                            _phoneController.text = _subAgentItem.phone;
                            _categoryController.text = _subAgentItem.place;
                            _datetimeController.text =
                                '${ConvertUtil.parseDateTimeToString(_subAgentItem.subAgentAt)}';
                          });
                        }
                        break;
                      case '삭제하기':
                        final response = await showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) =>
                              SubAgentDialog(
                            title: "삭제하시겠습니까?",
                            okButtonContent: "삭제",
                            cancelButtonContent: "취소",
                            onOkButtonClick: () async {
                              final subagentProvider =
                                  Provider.of<SubAgentProvider>(context,
                                      listen: false);
                              final delResult =
                                  await subagentProvider.delete(_subAgentItem);
                              if (delResult) {
                                Navigator.pop(context);
                              } else {
                                Utils.showSnackBar("삭제에 실패하였습니다.", context);
                              }
                            },
                          ),
                        );
                        if (response == DialogResponse.OK) {
                          Navigator.pop(context);
                        }
                        break;
                    }
                  },
                )
              ],
            )),
        Expanded(
            child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitle(_subAgentItem),
                SizedBox(
                  height: 10,
                ),
                buildDateTime(_subAgentItem),
                SizedBox(
                  height: 10,
                ),
                buildCategory(_subAgentItem),
                SizedBox(
                  height: 10,
                ),
                buildPay(_subAgentItem),
                SizedBox(
                  height: 10,
                ),
                buildPhoneNumber(_subAgentItem),
                SizedBox(
                  height: 10,
                ),
                buildContent(_subAgentItem),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        )),
        Container(
          width: double.infinity,
          height: 60,
          child: FlatButton(
            child: Text('복대리 수락', style: TextStyle(fontSize: 24)),
            onPressed: () async {
              final dialogResponse = await showDialog(
                context: context,
                builder: (BuildContext dialogContext) => SubAgentDialog(
                  title: "복대리를 수락하시겠습니까?",
                  okButtonContent: "수락",
                  cancelButtonContent: "취소",
                  onOkButtonClick: () async {},
                ),
              );
              if (dialogResponse == DialogResponse.OK) {
                Utils.showSnackBar("복대리가 수락되었습니다.", context, 1);
              }
            },
            color: Colors.blue,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }

  TextField buildTitle(SubAgentItem item) {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: '제목',
        labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
        enabled: false,
      ),
    );
  }

  TextFormField buildContent(SubAgentItem item) {
    return TextFormField(
      controller: _contentController,
      minLines: 10,
      maxLines: 150,
      decoration: InputDecoration(
        labelText: '내용',
        labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
        enabled: false,
      ),
    );
  }

  TextFormField buildCategory(SubAgentItem item) {
    return TextFormField(
      controller: _categoryController,
      decoration: InputDecoration(
        labelText: "장소",
        labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
        enabled: false,
      ),
    );
  }

  TextFormField buildPay(SubAgentItem item) {
    return TextFormField(
      controller: _payController,
      decoration: InputDecoration(
        labelText: '복대리 비용',
        labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
        enabled: false,
      ),
    );
  }

  TextFormField buildPhoneNumber(SubAgentItem item) {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: '전화번호',
        labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
        enabled: false,
      ),
    );
  }

  TextFormField buildDateTime(SubAgentItem item) {
    return TextFormField(
      controller: _datetimeController,
      decoration: InputDecoration(
        labelText: '복대리 날짜',
        labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
        enabled: false,
      ),
    );
  }

  IconButton buildBack(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context, null);
      },
    );
  }

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
}
