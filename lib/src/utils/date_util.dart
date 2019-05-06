import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateUtil {
  static final String pattern = 'dd/MM/yyyy';

  static String dateToString(Timestamp timeStamp) {
    if(timeStamp != null ) {
      var date = new DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
      return DateFormat(pattern).format(date);
    } else {
      return "";
    }
  }
}