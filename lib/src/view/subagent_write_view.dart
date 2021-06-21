import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/model/court_item.dart';
import 'package:subagent/src/model/subagent_item.dart';
import 'package:subagent/src/provider/court_provider.dart';
import 'package:subagent/src/provider/subagent_provider.dart';
import 'package:subagent/src/utils/convert_util.dart';
import 'package:subagent/src/utils/ui.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:subagent/src/utils/utils.dart';

class SubagentWriteView extends StatefulWidget {
  final SubAgentItem subAgentItem;

  const SubagentWriteView({Key key, this.subAgentItem}) : super(key: key);

  @override
  _SubagentWriteViewState createState() => _SubagentWriteViewState();
}

class _SubagentWriteViewState extends State<SubagentWriteView> {
  TextEditingController _titleController;
  TextEditingController _contentController;
  TextEditingController _payController;
  TextEditingController _phoneController;
  TextEditingController _datetimeController;
  TextEditingController _placeController;
  SubAgentItem _subAgentItem;

  GlobalKey<AutoCompleteTextFieldState<String>> _autoCompleteKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    _subAgentItem = widget.subAgentItem;
    _titleController = TextEditingController(
        text: _subAgentItem != null ? _subAgentItem.title : "");
    _contentController = TextEditingController(
        text: _subAgentItem != null ? _subAgentItem.content : "");
    _payController = TextEditingController(
        text: _subAgentItem != null
            ? _subAgentItem.pay.toString()
            : "");
    _phoneController = TextEditingController(
        text: _subAgentItem != null ? _subAgentItem.phone : "");
    _datetimeController = TextEditingController(
        text: widget.subAgentItem != null
            ? _subAgentItem.subAgentAt.toString()
            : DateTime.now().toString());
    _placeController = TextEditingController(
        text: widget.subAgentItem != null
            ? _subAgentItem.place.toString()
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
                InkWell(
                  child: Text(
                    '완료',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  onTap: () async {
                    // 글작성
                    final prov =
                        Provider.of<SubAgentProvider>(context, listen: false);

                    final item = SubAgentItem(
                        widget.subAgentItem == null ? null : widget.subAgentItem.idx,
                        _titleController.text,
                        _placeController.text,
                        _phoneController.text,
                        DateTime.parse(_datetimeController.text),
                        int.parse(_payController.text),
                        _contentController.text,
                        DateTime.now(),
                        DateTime.now());

                    final result = await prov.save(item);
                    if(result is String){
                      Utils.showSnackBar(result, context);
                    }else{
                      Navigator.pop(context, item);
                    }
                  },
                ),
              ],
            )),
        Expanded(
            child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitle(),
                SizedBox(
                  height: 10,
                ),
                buildDatePicker(),
                SizedBox(
                  height: 10,
                ),
                buildCategory(),
                SizedBox(
                  height: 10,
                ),
                buildPay(),
                SizedBox(
                  height: 10,
                ),
                buildPhoneNumber(),
                SizedBox(
                  height: 10,
                ),
                buildContent(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        )),
        Row(
          children: [],
        )
      ],
    );
  }

  TextField buildTitle() {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: '제목',
        labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
      ),
    );
  }

  TextFormField buildContent() {
    return TextFormField(
      controller: _contentController,
      minLines: 10,
      maxLines: 150,
      decoration: InputDecoration(
        labelText: '내용',
        labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
      ),
    );
  }

  TextFormField buildPay() {
    return TextFormField(
      controller: _payController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: '복대리 비용',
        labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
      ),
    );
  }

  TextFormField buildPhoneNumber() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: '전화번호',
        labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
      ),
    );
  }

  DateTimePicker buildDatePicker() {
    return DateTimePicker(
      controller: _datetimeController,
      type: DateTimePickerType.dateTime,
      locale: Locale('ko', 'KR'),
      dateMask: 'yyyy년 MM월 dd일  aa hh : mm',
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      icon: Icon(Icons.calendar_today_outlined),
      decoration: InputDecoration(
        labelText: '복대리 날짜',
        labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
      ),
      selectableDayPredicate: (date) {
        // Disable weekend days to select from the calendar
        if (date.weekday == 6 || date.weekday == 7) {
          return false;
        }
        return true;
      },
      onChanged: (val) => print("onChanged: " + val),
    );
  }

  Widget buildCategory() {
    final courtProv = Provider.of<CourtProvider>(context, listen: false);
    return SimpleAutoCompleteTextField(
      key: _autoCompleteKey,
      decoration: InputDecoration(
        labelText: '장소',
        labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
      ),
      controller: _placeController,
      suggestions: courtProv.courtStringList,
      // textChanged: (text) => _placeController.text = text,
      clearOnSubmit: false,
      textSubmitted: (text) => setState(() {
        if (text != "") {
          setState(() {
            _placeController.text = text;
          });
        }
      }),
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
}
