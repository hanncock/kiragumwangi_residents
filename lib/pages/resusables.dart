import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



TextStyle styler = const TextStyle(fontSize: 10,color: Colors.black45);
final frmtd = DateFormat('d MMMM , y');
final f = new DateFormat('yyyy-MM-dd');


formatCurrency(value) {
  if (value != null) {
    final formatCurrency = new NumberFormat.currency(
        locale: 'en_US', symbol: '', decimalDigits: 2);
    return formatCurrency.format(value);
  }
  return 0;
}