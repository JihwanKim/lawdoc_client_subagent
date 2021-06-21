import 'package:dio/dio.dart';
import 'package:subagent/src/model/user_info.dart';
import 'package:subagent/src/utils/api_utils.dart';

class UserAPI {
  static _responseToUserInfo(Map<String, dynamic> user) {
    final userInfo = UserInfo()
      ..idx = user['idx']
      ..nickName = user['name']
      ..type = "LAWYER" == user['type'] ? UserType.LAWYER : UserType.EMPLOYEE
      ..email = user['email']
      ..profileS3Key = user['profileS3Key']
      ..profileImgURL = null
      ..phoneNumber = user['phoneNumber']
      ..isAlarm = user['isAlarm']
      ..bankAccountInformation =
          user['bankAccount'] != null ? user['bankAccount']['info'] : null
      ..affiliationOffice = user['lawyerAffiliation'] != null
          ? user['lawyerAffiliation']['affiliationOffice']
          : null
      ..affiliationBranch = user['lawyerAffiliation'] != null
          ? user['lawyerAffiliation']['affiliationBranch']
          : null
      ..issueNumber = user['issueNumber'] != null ? user['issueNumber'] : null
      ..serialNumber =
          user['serialNumber'] != null ? user['serialNumber'] : null;
    return userInfo;
  }

  static Future getMyInfo(String accessToken) async {
    final apiURL = "${APIUtils.SERVER_URL}/subagent/v1/users";
    final dio = Dio();
    final response = await dio.get(apiURL,
        options: Options(headers: {"Authorization": "$accessToken"}));
    try {
      final user = APIUtils.responseHandler(response)['user'];
      return _responseToUserInfo(user);
    } catch (e) {
      return "not_exist_user";
    }
  }

  static Future updateMyInfo(
      String accessToken,
      String name,
      String phoneNumber,
      String office,
      String branch,
      String bankAccountInfo) async {
    final apiURL = "${APIUtils.SERVER_URL}/subagent/v1/users";
    final dio = Dio();
    final response = await dio.put(apiURL,
        data: {
          "name": name,
          "phoneNumber": phoneNumber,
          "lawyerAffiliationOffice": office,
          "lawyerAffiliationBranch": branch,
          "bankAccountInfo": bankAccountInfo,
        },
        options: Options(headers: {
          "Authorization": "$accessToken",
          "Content-Type": "application/json"
        }));
    try {
      final user = APIUtils.responseHandler(response)['user'];
      return _responseToUserInfo(user);
    } catch (e) {
      return "not_exist_user";
    }
  }

  static Future getUserInfo(int userIdx) async {
    final apiURL = "${APIUtils.SERVER_URL}/subagent/v1/users/$userIdx";
    final dio = Dio();
    final response = await dio.get(apiURL);

    return APIUtils.responseHandler(response);
  }
}
