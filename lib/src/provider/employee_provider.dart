import 'package:flutter/cupertino.dart';
import 'package:subagent/src/model/user_info.dart';
import 'package:subagent/src/utils/store.dart' as store;

class EmployeeProvider extends ChangeNotifier {
  final List<UserInfo> _employeeList = [];

  List<UserInfo> get list => _employeeList;

  EmployeeProvider() {
    for (int i = 0; i < 30; i++) {
      _employeeList.add(new UserInfo()
        ..email = "employee$i@test.com"
        ..profileS3Key = "original/default_profile.jpg"
        ..profileImgURL = null
        ..type = UserType.EMPLOYEE
        ..nickName = "A변호사 사무실 소속직원$i"
        ..isAlarm = true);
    }
  }
  Future<bool> remove(UserInfo userInfo) async{
    await Future.delayed(Duration(seconds: 2));
    list.remove(userInfo);
    notifyListeners();
    return true;
  }

  Future<bool> inviteByEmail(String email) async{
    await Future.delayed(Duration(seconds: 2));
    // reqeuset to server!
    return true;
  }
}
