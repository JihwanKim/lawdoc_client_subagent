import 'package:flutter/cupertino.dart';
import 'package:subagent/src/model/user_info.dart';
import 'package:subagent/src/utils/apis/user_api.dart';
import 'package:subagent/src/utils/store.dart' as store;

// 유저 정보는 앱실행시마다 서버에서 받아오도록.
class UserProvider extends ChangeNotifier {
  UserInfo _userInfo;

  UserInfo get userInfo => _userInfo;

  Future<bool> init() async {
    if (store.getAccessToken() != null) {
      final userInfo = await UserAPI.getMyInfo(store.getAccessToken());
      if (userInfo is UserInfo) {
        _userInfo = userInfo;
      }
      return true;
    }
    return false;
  }

  Future<bool> save(UserInfo userInfo) async {
    if (store.getAccessToken() != null) {
      final newUserInfo = await UserAPI.updateMyInfo(
          store.getAccessToken(),
          userInfo.nickName,
          userInfo.phoneNumber,
          userInfo.affiliationOffice,
          userInfo.affiliationBranch,
          userInfo.bankAccountInformation);
      if (newUserInfo is UserInfo) {
        _userInfo = newUserInfo;
      }
      return true;
    }
    return false;
  }

  Future<bool> logout() async {
    await Future.delayed(Duration(seconds: 2));
    _userInfo = null;
    notifyListeners();
    return true;
  }

  Future<bool> withdraw() async {
    await Future.delayed(Duration(seconds: 2));
    _userInfo = null;
    notifyListeners();
    return true;
  }

  Future<bool> changePassword(String beforePass, String afterPass) async {
    await Future.delayed(Duration(seconds: 2));

    return true;
  }
}
