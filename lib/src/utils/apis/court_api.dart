import 'package:dio/dio.dart';
import 'package:subagent/src/model/court_item.dart';
import 'package:subagent/src/utils/api_utils.dart';

class CourtAPI{

  static _responseToCourtInfo(Map<String, dynamic> item) {
    return CourtItem(item['name'], item['address'], item['phone']);
  }

  static Future getCourts(
      String accessToken
      ) async {
    final url =
        "${APIUtils.SERVER_URL}/subagent/v1/courts";

    final Map<String, dynamic> data = {};

    final dio = new Dio();
    final response = await dio.get(url,
        queryParameters: data,
        options: Options(headers: {"Authorization": "$accessToken"}));
    try {
      final List courts =
      APIUtils.responseHandler(response);
      return courts.map((e) {
        return _responseToCourtInfo(e);
      }).toList();
    } catch (e) {
      return "error!";
    }
  }
}