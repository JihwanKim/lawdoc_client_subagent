import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:subagent/src/model/board_item.dart';
import 'package:subagent/src/provider/board_provider.dart';
import 'package:subagent/src/utils/api_utils.dart';

class BoardAPI {
  static _responseToBoardInfo(Map<String, dynamic> board) {

    return new BoardItem(
      board['idx'],
      board['title'],
      board['content'],
      board['images'].cast<String>(),
      board['writeUser'] != null ? board['writeUser']['name'] : "",
      board['isMyBoard'],
      board['isAnonymous'],
      DateTime.parse(board['createTime']),
    );
  }

  static Future createBoard(
      String accessToken,
      BoardType boardType,
      String title,
      String content,
      List<String> images,
      bool isAnonymous) async {
    final url =
        "${APIUtils.SERVER_URL}/subagent/v1/boards/${boardType.toString().split('.').last}";

    final dio = new Dio();
    final response = await dio.post(url,
        data: {
          "title": title,
          "content": content,
          "images": images,
          "isAnonymous": isAnonymous
        },
        options: Options(headers: {"Authorization": "$accessToken"}));
    try {
      final subAgentBoard = APIUtils.responseHandler(response)['subAgentBoard'];
      return _responseToBoardInfo(subAgentBoard);
    } catch (e) {
      return "error!";
    }
  }

  static Future updateBoard(
      String accessToken,
      int boardIdx,
      String title,
      String content,
      List<String> images) async {
    final url =
        "${APIUtils.SERVER_URL}/subagent/v1/boards/$boardIdx";

    final dio = new Dio();
    final response = await dio.put(url,
        data: {
          "title": title,
          "content": content,
          "images": images
        },
        options: Options(headers: {"Authorization": "$accessToken"}));
    try {
      final subAgentBoard = APIUtils.responseHandler(response)['subAgentBoard'];
      return _responseToBoardInfo(subAgentBoard);
    } catch (e) {
      return "error!";
    }
  }

  static Future deleteBoard(
      String accessToken,
      int boardIdx) async {
    final url =
        "${APIUtils.SERVER_URL}/subagent/v1/boards/$boardIdx";

    final dio = new Dio();
    final response = await dio.delete(url,
        options: Options(headers: {"Authorization": "$accessToken"}));
    try {
      final subAgentBoard = APIUtils.responseHandler(response)['subAgentBoard'];
      return _responseToBoardInfo(subAgentBoard);
    } catch (e) {
      print("E? $e");
      return "error!";
    }
  }

  static Future getBoards(
    String accessToken,
    BoardType boardType, [
    int offsetBoardIdx,
  ]) async {
    final url =
        "${APIUtils.SERVER_URL}/subagent/v1/boards/${boardType.toString().split('.').last}";

    final Map<String, dynamic> data = {};
    if (offsetBoardIdx != null) {
      data['offsetBoardIdx'] = offsetBoardIdx;
    }

    final dio = new Dio();
    final response = await dio.get(url,
        queryParameters: data,
        options: Options(headers: {"Authorization": "$accessToken"}));
    try {
      final List subAgentBoards =
          APIUtils.responseHandler(response)['subAgentBoards'];
      return subAgentBoards.map((e) {
        return _responseToBoardInfo(e);
      }).toList();
    } catch (e) {
      return "error!";
    }
  }
}
