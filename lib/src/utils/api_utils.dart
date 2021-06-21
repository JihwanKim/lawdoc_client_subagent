import 'package:dio/dio.dart';
import 'package:subagent/src/model/user_info.dart';

class APIUtils {

  // static const SERVER_URL = "http://172.30.1.22:5000";
  static const SERVER_URL = "http://-----:5000";

  static getUserInfo(int userIdx) => "$SERVER_URL/subagent/v1/users/$userIdx";


  static createSubAgent() => "$SERVER_URL/subagent/v1/subagents";

  // 일반 게시글 노출용
  static getAllDefaultSubAgent({int offsetSubAgentIdx}) => "$SERVER_URL/subagent/v1/subagents?type=DEFAULT${offsetSubAgentIdx != null ? '&offsetSubAgentIdx='+offsetSubAgentIdx.toString() : ''}";



  static responseHandler(Response response){
    if(response.statusCode == 200){
      return response.data;
    }else{
      return throw(response.data);
    }
  }
}
