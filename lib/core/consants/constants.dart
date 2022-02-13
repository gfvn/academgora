import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';



String sorting(){
  var year = formatDate(DateTime.now(), [yyyy]);
  var day = formatDate(DateTime.now(), [dd]);
  var k = DateFormat('kk').format(DateTime.now());
  var m = DateFormat('mm').format(DateTime.now());
  var s = DateFormat('ss').format(DateTime.now());
  return '$year$day$k$m$s';
}