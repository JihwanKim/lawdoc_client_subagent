import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/model/user_info.dart';
import 'package:subagent/src/page/add_employee_page.dart';
import 'package:subagent/src/provider/employee_provider.dart';
import 'package:subagent/src/provider/subagent_image_provider.dart';
import 'package:subagent/src/widget/subagent_dialog.dart';

class EmployeeManagementView extends StatefulWidget {
  @override
  _EmployeeManagementViewState createState() => _EmployeeManagementViewState();
}

class _EmployeeManagementViewState extends State<EmployeeManagementView> {
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
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => AddEmployeePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmployee(UserInfo employeeUserInfo) {
    final double width = MediaQuery.of(context).size.width;
    _getProfileURL(employeeUserInfo);
    return Card(
      child: Row(
        children: [
          Container(
            width: width * 0.3,
            child: employeeUserInfo.profileImgURL == null
                ? Container(
                    padding: EdgeInsets.all(8.0),
                    width: width * 0.1,
                    height: width * 0.1,
                    child: CupertinoActivityIndicator(),
                  )
                : Image.network(employeeUserInfo.profileImgURL),
          ),
          Column(
            children: [
              Row(
                children: [
                  Text("이름 - "),
                  Text("${employeeUserInfo.nickName}"),
                ],
              ),
              Row(
                children: [
                  Text("이메일 - "),
                  Text("${employeeUserInfo.email}"),
                ],
              ),
              OutlineButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) => SubAgentDialog(
                      title: "직원을 제거 하시겠습니까?",
                      okButtonContent: "제거",
                      cancelButtonContent: "취소",
                      onOkButtonClick: () async {
                        final employeeProv = Provider.of<EmployeeProvider>(
                            context,
                            listen: false);
                        await employeeProv.remove(employeeUserInfo);
                      },
                    ),
                  );
                },
                child: Text("제거"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _getProfileURL(UserInfo employeeUserInfo) async {
    if (employeeUserInfo.profileImgURL == null) {
      final imageProv = Provider.of<SubAgentImageProvider>(context);
      final imageURL =
          await imageProv.getByS3Key(employeeUserInfo.profileS3Key);
      setState(() {
        employeeUserInfo.profileImgURL = imageURL;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final employeeProv = Provider.of<EmployeeProvider>(context);
    final employeeList = employeeProv.list;
    return Column(
      children: [
        _buildAppBar(),
        Expanded(
          child: ListView.builder(
            itemCount: employeeList.length,
            itemBuilder: (context, index) {
              return _buildEmployee(employeeList[index]);
            },
          ),
        ),
      ],
    );
  }
}
