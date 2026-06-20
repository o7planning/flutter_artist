import 'package:flutter/material.dart';

class LocaleUtils {
  static Locale? fromCode(String localeCode) {
    List<String> ss = localeCode.split("-");
    if (ss.length == 1) {
      return Locale(ss[0]);
    } else if (ss.length == 2) {
      return Locale(ss[0], ss[1]);
    } else {
      return null;
    }
  }
}
