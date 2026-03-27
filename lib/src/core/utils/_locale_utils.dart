import 'package:flutter/material.dart';

class LocaleUtils {
  static Locale? fromCode(String localeCode) {
    List<String> ss = localeCode.split("-");
    if (ss.length < 2) {
      return null;
    }
    if (ss[0] != 2) {
      return null;
    }
    return Locale(ss[0], ss[1]);
  }
}
