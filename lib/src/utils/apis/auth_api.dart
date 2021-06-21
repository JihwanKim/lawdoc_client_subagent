import 'package:dio/dio.dart';
import 'package:subagent/src/model/user_info.dart';
import 'package:subagent/src/utils/api_utils.dart';

class AuthAPI{
  static Future signUpForNormal({
    authType="NORMAL",
    String id,
    String password,
    String name,
    String email,
    String birthday,
    String phoneNumber,
    UserType userType = UserType.LAWYER,

    // 변호사 필수
    String serialNumber,
    String issueNumber,
  }) async {
    const url = APIUtils.SERVER_URL;
    final dio = new Dio();
    final response = await dio.post(url,data:{
      authType:authType,
      id:id,
      password:password,
      name:name,
      email:email,
      birthday:birthday,
      phoneNumber:phoneNumber,
      userType:userType.toString(),
      serialNumber:serialNumber,
      issueNumber:issueNumber
    });
    try {
    }catch(e){
      return "not_exist_user";
    }
  }
  // 로그인 - POST
  static signIn() => "${APIUtils.SERVER_URL}/v1/auths/session";

  // 비밀번호 변경 - PUT
}