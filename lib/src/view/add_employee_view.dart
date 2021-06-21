import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/provider/employee_provider.dart';
import 'package:subagent/src/utils/ui.dart';
import 'package:subagent/src/utils/utils.dart';

class AddEmployeeView extends StatefulWidget {
  @override
  _AddEmployeeViewState createState() => _AddEmployeeViewState();
}

class _AddEmployeeViewState extends State<AddEmployeeView> {
  TextEditingController _textEditingController;

  bool _isInvite = false;
  Widget _buildAppBar() {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          _isInvite ? Container(
              padding: EdgeInsets.all(8.0),
              child: CupertinoActivityIndicator()) :
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              if(_isInvite){
                Utils.showSnackBar("초대중입니다.", context);
                return;
              }

              if (_textEditingController.text.length == 0) {
                await Utils.showSnackBar("이메일을 입력하여 주십시오.", context);
                return;
              } else {
                final employeeProv = Provider.of<EmployeeProvider>(context,listen: false);
                await Utils.showSnackBar("직원 초대중입니다.", context, 1);
                setState(() {
                  _isInvite = true;
                });
                if(await employeeProv.inviteByEmail(_textEditingController.text)){
                  await Utils.showSnackBar("직원 초대에 성공하였습니다.", context);
                  Navigator.pop(context);
                }else{
                  await Utils.showSnackBar("직원 초대에 실패하였습니다.", context);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBar(),
        Expanded(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    labelText: "대상 직원 Email"),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
