import 'package:flutter/cupertino.dart';
import 'package:subagent/src/utils/apis/subagent_api.dart';
import 'package:subagent/src/utils/store.dart' as store;

import '../model/subagent_item.dart';

class SubAgentProvider extends ChangeNotifier {
  bool _isMore = true;
  String _accessToken = "4_accessTokenSample";

  final List<SubAgentItem> _subAgentList = [];
  final List<String> _courtList = [];

  List get subAgentList => _subAgentList.toList();

  List<String> get courList => _courtList.toList();


  Future save(SubAgentItem item) async {
    if (item.idx != null) {
      final response = await SubAgentAPI.updateSubAgent(
          store.getAccessToken(),
          item.idx,
          item.title,
          item.content,
          item.place,
          item.subAgentAt,
          item.pay,
          item.phone);
      if (response is String) {
        return "err";
      } else {
        for (int i = 0; i < _subAgentList.length; i++) {
          if (_subAgentList[i].idx == item.idx) {
            _subAgentList[i] = item;
          }
        }
      }
      notifyListeners();
      return response;
    } else {
      final response = await SubAgentAPI.createSubAgent(
          _accessToken,
          item.title,
          item.content,
          item.place,
          item.subAgentAt,
          item.pay,
          item.phone);
      if (response is String) {
        return "err";
      } else {
        _subAgentList.insert(0, response);
      }
      notifyListeners();
      return response;
    }
  }

  // load / load more wrapping methods. for normal, my requests, requesting, accept
  // 복대리 전체조회
  Future loadNormal({
    int offsetSubAgentIdx,
    List<String> locations,
  }) async {
    return await _load(
        requestingType: SubAgentShowTypes.BOARD,
        offsetSubAgentIdx: offsetSubAgentIdx,
        locations: locations);
  }

  // 내가 올린 복대리글만 가져오기
  Future loadRequesting({
    int offsetSubAgentIdx,
    List<String> locations,
  }) async {
    return await _load(
        requestingType: SubAgentShowTypes.REQUESTING,
        offsetSubAgentIdx: offsetSubAgentIdx,
        locations: locations);
  }

  // 내가 신청한 복대리글만 가져오기.
  Future loadRequests({
    int offsetSubAgentIdx,
    List<String> locations,
  }) async {
    return await _load(
        requestingType: SubAgentShowTypes.REQUEST,
        offsetSubAgentIdx: offsetSubAgentIdx,
        locations: locations);
  }

  // 요청에 대해 승인된 복대리글만 가져오기.
  Future loadAccept({
    int offsetSubAgentIdx,
    List<String> locations,
  }) async {
    return await _load(
        requestingType: SubAgentShowTypes.ACCEPTED,
        offsetSubAgentIdx: offsetSubAgentIdx,
        locations: locations);
  }

  Future<bool> _load(
      {int offsetSubAgentIdx,
        List<String> locations,
      int subAgentIdx,
      SubAgentShowTypes requestingType}) async {
    _isMore = true;
    _subAgentList.clear();
    return await _loadMore(
      offsetSubAgentIdx: offsetSubAgentIdx,
      locations: locations,
      subAgentIdx: subAgentIdx,
      requestingType: requestingType,
    );
  }

  Future<bool> _loadMore(
      {int offsetSubAgentIdx,
      List<String> locations,
      int subAgentIdx,
      SubAgentShowTypes requestingType}) async {
    if (!_isMore) {
      return _isMore;
    }

    final response = await SubAgentAPI.getSubAgents(store.getAccessToken(),
        offsetSubAgentIdx: offsetSubAgentIdx,
        locations: locations,
        subAgentIdx: subAgentIdx,
        requestingType: requestingType);
    if (response is String) {
      // err! err 처리 추가필요!
    } else {
      final List<SubAgentItem> responseItems = response.cast<SubAgentItem>();
      if (responseItems.length == 0) {
        _isMore = false;
      }

      _subAgentList.addAll(responseItems);
      notifyListeners();
    }
    return true;
  }

  Future<bool> delete(SubAgentItem item) async {
    await Future.delayed(Duration(seconds: 1));
    final response = await SubAgentAPI.deleteSubAgent(store.getAccessToken(), item.idx);
    if (response is String) {
      // 실패시 알람 어캐띄워줄지 ?
      return false;
    } else if (response is SubAgentItem) {
      _subAgentList.remove(item);
      notifyListeners();
      return true;
    }
    return false;
  }
}
