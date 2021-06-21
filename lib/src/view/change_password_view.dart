import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/provider/user_provider.dart';
import 'package:subagent/src/utils/ui.dart';
import 'package:subagent/src/utils/utils.dart';

class ChangePasswordView extends StatefulWidget {
  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  TextEditingController _beforeTextEditingController;
  TextEditingController _afterTextEditingController;
  TextEditingController _afterConfirmTextEditingController;
  bool _isRun = false;

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

  Widget _buildChangePasswordArea() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _beforeTextEditingController,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
              labelText: "현재 비밀번호",
              icon: Icon(
                Icons.lock,
                color: Colors.blue,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _afterTextEditingController,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
              labelText: "변경 비밀번호",
              icon: Icon(
                Icons.lock,
                color: Colors.blue,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _afterConfirmTextEditingController,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
              labelText: "변경 비밀번호 확인",
              icon: Icon(
                Icons.lock,
                color: Colors.blue,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          _isRun
              ? CupertinoActivityIndicator()
              : OutlineButton(
                  onPressed: () async {
                    if (_isRun) {
                      Utils.showSnackBar(
                          "비밀번호 변경중입니다. 잠시 후 다시 시도해 주세요.", context);
                      return;
                    }
                    if (_beforeTextEditingController.text == "") {
                      Utils.showSnackBar("현재 비밀번호를 입력하여 주십시오", context);
                      return;
                    }
                    if (_afterTextEditingController.text == "") {
                      Utils.showSnackBar("변경 비밀번호를 입력하여 주십시오", context);
                      return;
                    }
                    if (_afterConfirmTextEditingController.text !=
                        _afterTextEditingController.text) {
                      Utils.showSnackBar(
                          "변경 비밀번호와 확인 비밀번호가 일치하지 않습니다.", context);
                      return;
                    }

                    FocusScope.of(context).unfocus();
                    setState(() {
                      _isRun = true;
                    });

                    final userProv =
                        Provider.of<UserProvider>(context, listen: false);
                    if (await userProv.changePassword(
                        _beforeTextEditingController.text,
                        _afterConfirmTextEditingController.text)) {
                      setState(() {
                        _isRun = false;
                      });
                      await Utils.showSnackBar("비밀번호가 변경되었습니다.", context);
                      Navigator.pop(context);
                    } else {
                      Utils.showSnackBar("비밀번호 변경에 실패하였습니다.", context);
                      setState(() {
                        _isRun = false;
                      });
                    }
                  },
                  child: Text("변경"),
                ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _beforeTextEditingController = TextEditingController();
    _afterTextEditingController = TextEditingController();
    _afterConfirmTextEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBar(),
        Expanded(child: _buildChangePasswordArea()),
      ],
    );
  }
}
