import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/model/user_info.dart';
import 'package:subagent/src/page/change_password_page.dart';
import 'package:subagent/src/page/employee_management_page.dart';
import 'package:subagent/src/page/profile_page.dart';
import 'package:subagent/src/page/subagent_history_page.dart';
import 'package:subagent/src/provider/employee_provider.dart';
import 'package:subagent/src/provider/user_provider.dart';
import 'package:subagent/src/widget/subagent_dialog.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  Widget _buildProfileChange() {
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text("프로필")),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordChange() {
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ChangePasswordPage(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text("비밀번호 변경")),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeView() {
    final employeeProv = Provider.of<EmployeeProvider>(context);
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => EmployeeManagementPage(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text("직원 관리 ( ${employeeProv.list.length}명 )")),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubAgentHistory() {
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SubAgentHistoryPage(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text("복대리 히스토리")),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogout() {
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) => SubAgentDialog(
                  title: "로그아웃 하시겠습니까?",
                  okButtonContent: "로그아웃",
                  cancelButtonContent: "취소",
                  onOkButtonClick: () async {
                    final userProv =
                        Provider.of<UserProvider>(context, listen: false);
                    await userProv.logout();
                  },
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text("로그아웃")),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWithdraw() {
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) => SubAgentDialog(
                  title: "회원 탈퇴 하시겠습니까?",
                  okButtonContent: "탈퇴",
                  cancelButtonContent: "취소",
                  onOkButtonClick: () async {
                    final userProv =
                        Provider.of<UserProvider>(context, listen: false);
                    await userProv.withdraw();
                  },
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text("탈퇴")),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context, listen: false);
    return Column(
      children: [
        _buildProfileChange(),
        _buildPasswordChange(),
        _buildSubAgentHistory(),
        if (userProv.userInfo.type == UserType.LAWYER) _buildEmployeeView(),
        _buildLogout(),
        Divider(),
        _buildWithdraw(),
      ],
    );
  }
}
