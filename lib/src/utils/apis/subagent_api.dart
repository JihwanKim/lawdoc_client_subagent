import 'package:dio/dio.dart';
import 'package:subagent/src/model/subagent_item.dart';
import 'package:subagent/src/utils/api_utils.dart';

class SubAgentAPI{

  static _responseToSubAgent(Map<String, dynamic> item) {
    // this.idx, this.title, this.place, this.phone, this.subAgentAt,
    // this.pay, this.content, this.createAt, this.updateAt
    return new SubAgentItem(
      item['idx'],
      item['title'],
      item['court'],
      item['phoneNumber'] == null ? item['requestingUser']['phoneNumber'] : item['phoneNumber'],
      DateTime.parse(item['trialStartTime']),
      item['pay'],
      item['content'],
      DateTime.parse(item['createTime']),
      DateTime.parse(item['updateTime']),
    );
  }

  static Future createSubAgent(
      String accessToken,
      String title,
      String content,
      String place,
      DateTime trialStartTime,
      int pay,
      String phoneNumber) async {
    final url =
        "${APIUtils.SERVER_URL}/subagent/v1/subagents";

    final dio = new Dio();
    final response = await dio.post(url,
        data: {
          "title": title,
          "content": content,
          "court": place,
          "pay": pay,
          "trialStartTime": trialStartTime.toString(),
          "phoneNumber":phoneNumber
        },
        options: Options(headers: {"Authorization": "$accessToken"}));
    try {
      final subAgent = APIUtils.responseHandler(response)['subAgent'];
      return _responseToSubAgent(subAgent);
    } catch (e) {
      return "error!";
    }
  }

  static Future updateSubAgent(
      String accessToken,
      int subAgentIdx,
      String title,
      String content,
      String place,
      DateTime trialStartTime,
      int pay,
      String phoneNumber) async {
    final url =
        "${APIUtils.SERVER_URL}/subagent/v1/subagents/$subAgentIdx";

    final dio = new Dio();
    final response = await dio.put(url,
        data: {
          "title": title,
          "content": content,
          "court": place,
          "pay": pay,
          "trialStartTime": trialStartTime.toString(),
          "phoneNumber":phoneNumber
        },
        options: Options(headers: {"Authorization": "$accessToken"}));
    try {
      final subAgentBoard = APIUtils.responseHandler(response)['subAgent'];
      return _responseToSubAgent(subAgentBoard);
    } catch (e) {
      return "error!";
    }
  }

  static Future deleteSubAgent(
      String accessToken,
      int subAgentIdx) async {
    final url =
        "${APIUtils.SERVER_URL}/subagent/v1/subagents/$subAgentIdx";

    final dio = new Dio();
    try {
      final response = await dio.delete(url,
          options: Options(headers: {"Authorization": "$accessToken"}));
      final subAgentBoard = APIUtils.responseHandler(response)['subAgent'];
      return _responseToSubAgent(subAgentBoard);
    } catch (e) {
      if(e is DioError){

        print("e ? ${e.response}");
        print("e ? ${e}");
        return e.response;
      }
      return "error!";
    }
  }

  static Future getSubAgents(
      String accessToken,
      {
        int subAgentIdx,
        int offsetSubAgentIdx,
        // "BOARD", "REQUESTING", "REQUEST", "ACCEPTED"
        SubAgentShowTypes requestingType,
        List<String> locations,
      }) async {
    final url =
        "${APIUtils.SERVER_URL}/subagent/v1/subagents${subAgentIdx == null ? '' : '/$subAgentIdx'}";

    final Map<String, dynamic> data = {};
    if(subAgentIdx == null){
      if (offsetSubAgentIdx != null) {
        data['offsetSubAgentIdx'] = offsetSubAgentIdx;
      }
      if(locations != null && locations.length > 0){
        data['courts'] = locations.join(",");
      }
    }

    final dio = new Dio();
    final response = await dio.get(url,
        queryParameters: data,
        options: Options(headers: {"Authorization": "$accessToken"}));
    try {
      final List subAgentBoards =
      APIUtils.responseHandler(response)['subAgents'];
      return subAgentBoards.map((e) {
        return _responseToSubAgent(e);
      }).toList();
    } catch (e) {
      return "error!";
    }
  }
}