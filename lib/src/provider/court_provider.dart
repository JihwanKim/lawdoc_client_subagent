import 'package:flutter/cupertino.dart';
import 'package:subagent/src/model/court_item.dart';
import 'package:subagent/src/utils/apis/court_api.dart';
import 'package:subagent/src/utils/store.dart' as store;

class CourtProvider extends ChangeNotifier {

  final List<CourtItem> _courtList = [];
  final List<String> _courtFilterList = [];

  final List<String> _courtPlaceList = [];

  List<String> get courtStringList => _courtPlaceList;
  List<String> get filterItems => _courtFilterList;

  bool get isHasFilter{
    if(_courtFilterList.length > 0){
      return true;
    }
    return false;
  }

  List<CourtItem> courtList({String filterStr}) {
    List<CourtItem> list = List<CourtItem>.from(_courtList);
    if (filterStr != null && filterStr != "") {
      list = list
          .where((element) => element.name.contains(filterStr))
          .toList()
          .cast<CourtItem>();
    }
    return list;
  }

  init() async {
    _courtFilterList.clear();
    final loadCourtFilterRs = store.loadCourtFilter();
    if(loadCourtFilterRs!=null){
      _courtFilterList.addAll(loadCourtFilterRs);
    }

    final response = await CourtAPI.getCourts(store.getAccessToken());
    //.cast<BoardItem>()
    if (response is String) {
    } else {
      final List<CourtItem> responseCourts = response.cast<CourtItem>();
      _courtList.addAll(responseCourts);
      responseCourts.forEach((element) {
        _courtPlaceList.add(element.name);
      });
      // filter 적용.
      _courtList.forEach((element) {
        if(_courtFilterList.contains(element.name)){
          element.isFilter = true;
        }
      });
    }
  }

  addFilter(CourtItem any) {
    any.isFilter = true;
    _courtFilterList.add(any.name);
    store.saveCourtFilter(_courtFilterList);
    notifyListeners();
  }

  removeFilter(CourtItem any) {
    any.isFilter = false;
    _courtFilterList.remove(any.name);
    store.saveCourtFilter(_courtFilterList);
    notifyListeners();
  }
}
