import 'package:dio/dio.dart';
import 'package:subagent/src/model/reply_item.dart';
import 'package:subagent/src/utils/api_utils.dart';

class ReplyAPI{
  static _responseToBoardReply(Map<String, dynamic> board) {

    return new ReplyItem(
      board['idx'],
      board['content'],
      board['writeUser'] != null ? board['writeUser']['name'] : "",
      board['isMyReply'],
      board['isAnonymous'],
      DateTime.parse(board['createTime']),
    );
  }

  static Future createReply(
      String accessToken,
      int boardIdx,
      String content,
      bool isAnonymous) async {
    final url =
        "${APIUtils.SERVER_URL}/subagent/v1/boards/$boardIdx/replies";

    final dio = new Dio();
    final response = await dio.post(url,
        data: {
          "content": content,
          "isAnonymous": isAnonymous
        },
        options: Options(headers: {"Authorization": "$accessToken"}));
    try {
      final reply = APIUtils.responseHandler(response)['reply'];
      return _responseToBoardReply(reply);
    } catch (e) {
      return "error!";
    }
  }

  static Future updateReply(
      String accessToken,
      int boardIdx,
      int replyIdx,
      String content,) async {
    final url =
        "${APIUtils.SERVER_URL}/subagent/v1/boards/$boardIdx/replies/$replyIdx";

    final dio = new Dio();
    final response = await dio.put(url,
        data: {
          "content": content,
        },
        options: Options(headers: {"Authorization": "$accessToken"}));
    try {
      final reply = APIUtils.responseHandler(response)['reply'];
      return _responseToBoardReply(reply);
    } catch (e) {
      return "error!";
    }
  }

  static Future deleteReply(
      String accessToken,
      int boardIdx,
      int replyIdx) async {
    final url =
        "${APIUtils.SERVER_URL}/subagent/v1/boards/$boardIdx/replies/$replyIdx";

    final dio = new Dio();
    final response = await dio.delete(url,
        options: Options(headers: {"Authorization": "$accessToken"}));
    try {
      final reply = APIUtils.responseHandler(response)['reply'];
      return _responseToBoardReply(reply);
    } catch (e) {
      return "error!";
    }
  }

  static Future getReplies(
      String accessToken,
      int boardIdx, [
        int offsetReplyIdx,
      ]) async {
    final url =
        "${APIUtils.SERVER_URL}/subagent/v1/boards/$boardIdx/replies";

    final Map<String, dynamic> data = {};
    if (offsetReplyIdx != null) {
      data['offsetReplyIdx'] = offsetReplyIdx;
    }

    final dio = new Dio();
    final response = await dio.get(url,
        queryParameters: data,
        options: Options(headers: {"Authorization": "$accessToken"}));
    try {
      final List subAgentBoardReplies =
      APIUtils.responseHandler(response)['replies'];
      return subAgentBoardReplies.map((e) {
        return _responseToBoardReply(e);
      }).toList();
    } catch (e) {
      return "error!";
    }
  }

}