import 'package:flutter/cupertino.dart';
import 'package:subagent/src/model/board_item.dart';
import 'package:subagent/src/utils/apis/board_api.dart';
import 'package:subagent/src/utils/store.dart' as store;

enum BoardType {
  ALL,
  ALL_QA,
  LAWYER,
  LAWYER_QA,
}

class BoardProvider extends ChangeNotifier {
  bool _isLoad = false;
  bool _isMore = true;

  final List<BoardItem> _boardItems = [];

  BoardProvider() {
    load(BoardType.ALL);
  }

  List get list => _boardItems.toList();
  bool get isLoad => _isLoad;

  load(BoardType type) async {
    _boardItems.clear();
    _isMore = true;
    _isLoad = true;

    await Future.delayed(Duration(seconds: 1));

    final response = await BoardAPI.getBoards(store.getAccessToken(), type);
    if (response is String) {
      // err! err 처리 추가필요!
    } else {
      final List<BoardItem> responseBoards = response.cast<BoardItem>();
      if (responseBoards.length == 0) {
        _isMore = false;
      }

      _boardItems.addAll(responseBoards);
    }

    _isLoad = false;
    notifyListeners();
  }

  save(BoardType type, BoardItem item) async {
    if (item.idx != null) {
      final response = await BoardAPI.updateBoard(
          store.getAccessToken(), item.idx, item.title, item.content, item.images);
      if (response is String) {
        return "";
      } else {
        for (int i = 0; i < _boardItems.length; i++) {
          if (_boardItems[i].idx == item.idx) {
            _boardItems[i] = item;
          }
        }
      }
    } else {
      final response = await BoardAPI.createBoard(store.getAccessToken(), type,
          item.title, item.content, item.images, item.isAnonymous);
      if (response is String) {
        return "";
      } else {
        _boardItems.insert(0, response);
      }
    }
    notifyListeners();
  }

  Future<bool> loadMore(BoardType type, int lastIdx) async {
    if (!_isMore) {
      return _isMore;
    }

    await Future.delayed(Duration(seconds: 1));

    final response = await BoardAPI.getBoards(store.getAccessToken(), type, lastIdx);
    if (response is String) {
      // err! err 처리 추가필요!
    } else {
      final List<BoardItem> responseBoards = response.cast<BoardItem>();
      if (responseBoards.length == 0) {
        _isMore = false;
      }

      _boardItems.addAll(responseBoards);
    }

    return true;
  }

  Future<bool> remove(BoardItem item) async {
    await Future.delayed(Duration(seconds: 1));
    await Future.delayed(Duration(seconds: 1));
    final response = await BoardAPI.deleteBoard(store.getAccessToken(), item.idx);
    if(response is String){
      // 실패시 알람 어캐띄워줄지 ?

      return false;
    }else if (response is BoardItem){
      _boardItems.remove(item);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> report(BoardItem item) async {
    await Future.delayed(Duration(seconds: 1));
    // _boardItems.remove(item.idx);

    notifyListeners();
    return true;
  }
}
