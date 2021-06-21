import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences _pref;

initPref() async {
  _pref = await SharedPreferences.getInstance();
}

saveCourtFilter(List<String> items){
  _pref.setStringList("court_filter", items);
}

loadCourtFilter(){
  return _pref.getStringList("court_filter");
}

saveAccessToken(String token){
  _pref.setString("access_token", token);
}

getAccessToken(){
  // return _pref.getString("access_token");
  return "4_accessTokenSample";
}