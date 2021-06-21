import 'package:intl/intl.dart';

class ConvertUtil {
  /// 날짜 관련 유틸
  static DateTime convertStringToDateTime(String dateTime) {
    return DateFormat("yyyy-MM-dd hh:mm:ss", 'ko').parse(dateTime);
  }

  static String parseDateTimeToString(DateTime dateTime) {
    return DateFormat('yyyy년 MM월 dd일 aa hh:mm', 'ko').format(dateTime);
  }

  // static String parseDateTime(String dateTime) {
  //   return DateFormat('yyyy-MM-dd aa hh:mm', 'ko')
  //       .format(convertStringToDateTime(dateTime));
  // }

  static String parseAmOrPm(String dateTime) {
    return DateFormat('aa', 'ko').format(convertStringToDateTime(dateTime));
  }


  static String parseDate(String dateTime) {
    return DateFormat('yyyy년 MM월 dd일', 'ko').format(convertStringToDateTime(dateTime));
  }

  static String parseTime(String dateTime) {
    return DateFormat('hh:mm', 'ko').format(convertStringToDateTime(dateTime));
  }

  /// 단위관련 유틸
  static String parsePrice(int price) {
    final formatCurrency = new NumberFormat.simpleCurrency(
        locale: "ko_KR", name: "", decimalDigits: 0);
    return formatCurrency.format(price);
  }
}
