import 'package:intl/intl.dart';
String formattedDate(DateTime dateTime){
  var formatter = new DateFormat('yyyy/MM/dd(E)', "ja_JP");
  return formatter.format(dateTime);
}