import 'package:intl/intl.dart';

class NumberUtils {
  static final _formatter = new NumberFormat('R\$ #,##0.00');

  static String numberFormat(double value) {
    return _formatter.format(value);
  }
}