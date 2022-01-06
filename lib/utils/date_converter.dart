import 'package:intl/intl.dart';

DateTime hours12To24(String hours12){
  return DateFormat('yyyy-MM-dd hh:mm a').parse(hours12);
}

String hours24To12(DateTime hours24){
  return DateFormat('yyyy-MM-dd hh:mm a').format(hours24);
}

DateTime jsonToDateTime(String date) {
  return DateFormat('yyyy-MM-dd HH:mm').parse(date);
}

String dateToJsonString(DateTime date) {
  return DateFormat('yyyy-MM-dd HH:mm').format(date);
}

String durationToStringClock(Duration duration) {
  int days = duration.inDays;
  int hours = duration.inHours.remainder(24);
  int minutes = duration.inMinutes.remainder(60);
  String twoDigits(int n) => n.toString();
  String twoDigitsDays = twoDigits(days);
  String twoDigitsHours = twoDigits(hours);
  String twoDigitMinutes = twoDigits(minutes);
  return  (days > 0 ? "$twoDigitsHours Hours " : "") + (hours > 0 ? "$twoDigitsHours Hours " : "") + "$twoDigitMinutes Minutes";
}