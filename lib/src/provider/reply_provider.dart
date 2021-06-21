import 'package:flutter/cupertino.dart';
import 'package:subagent/src/model/reply_item.dart';
import 'package:subagent/src/utils/apis/reply_api.dart';
import 'package:subagent/src/utils/store.dart' as store;

class ReplyProvider extends ChangeNotifier {
  bool _isMore = true;
  final List<ReplyItem> _replyList = [];

  List<ReplyItem> get list => _replyList.toList();

  Future save(int boardIdx, ReplyItem item) async {
    if (item.idx != null) {
      final response = await ReplyAPI.updateReply(
          store.getAccessToken(), boardIdx, item.idx, item.content);
      if (response is String) {
        return "";
      } else {
        for (int i = 0; i < _replyList.length; i++) {
          if (_replyList[i].idx == item.idx) {
            _replyList[i] = item;
          }
        }
      }
      notifyListeners();
      return response;
    } else {
      final response = await ReplyAPI.createReply(
          store.getAccessToken(), boardIdx, item.content, item.isAnonymous);
      if (response is String) {
        return "";
      } else {
        _replyList.add(response);
      }
      notifyListeners();
      return response;
    }
  }

  Future remove(int boardIdx, ReplyItem item) async {
    await Future.delayed(Duration(seconds: 1));
    final response = await ReplyAPI.deleteReply(store.getAccessToken(), boardIdx, item.idx);
    if(response is String){
      // 실패시 알람 어캐띄워줄지 ?
    }else if (response is ReplyItem){
      _replyList.remove(item.idx);
    }

    notifyListeners();
    return true;
  }

  Future<bool> load(int boardIdx) async {
    _isMore = true;
    _replyList.clear();
    return loadMore(boardIdx);
  }

  Future<bool> loadMore(int boardIdx, [int offsetReplyIdx]) async {
    if (!_isMore) {
      return _isMore;
    }

    await Future.delayed(Duration(seconds: 1));

    final response =
        await ReplyAPI.getReplies(store.getAccessToken(), boardIdx, offsetReplyIdx);
    if (response is String) {
      // err! err 처리 추가필요!
    } else {
      final List<ReplyItem> responseBoards = response.cast<ReplyItem>();
      if (responseBoards.length == 0) {
        _isMore = false;
      }

      _replyList.addAll(responseBoards);
      notifyListeners();
    }

    return true;
  }

  Future<bool> report(ReplyItem item) async {
    Future.delayed(Duration(seconds: 1));

    return true;
  }
}
