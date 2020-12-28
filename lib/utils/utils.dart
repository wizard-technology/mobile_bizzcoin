import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double screenHeight(BuildContext context, {double dividedBy = 1}) {
  return screenSize(context).height / dividedBy;
}

double screenWidth(BuildContext context, {double dividedBy = 1}) {
  return screenSize(context).width / dividedBy;
}

bool checkIfIpad(BuildContext context) {
  if (screenWidth(context) > 600) {
    return true;
  } else {
    return false;
  }
}

String convertStrToDate(date) =>
    DateFormat("yyyy-MM-dd hh:mm:ss a").format(DateTime.parse(date));
