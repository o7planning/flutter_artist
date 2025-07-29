part of '../_fa_core.dart';

// -----------------------------------------------------------------------------

String? _trimStringToNullIfEmpty(String? s) {
  if (s == null) {
    return null;
  }
  String s1 = s.trim();
  return s1.isEmpty ? null : s1;
}

// -----------------------------------------------------------------------------

String? _stringToNullIfEmpty(String? s) {
  if (s == null) {
    return null;
  }
  return s.isEmpty ? null : s;
}

// -----------------------------------------------------------------------------
