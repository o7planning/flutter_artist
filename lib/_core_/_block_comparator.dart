part of '../flutter_artist.dart';

class _SignAndPropName {
  String sign;
  String propName;

  _SignAndPropName({required this.sign, required this.propName});

  bool isAsc() {
    return sign == "+";
  }

  bool isDesc() {
    return sign == "-";
  }

  static _SignAndPropName parse(String sortablePropName) {
    String pn = sortablePropName.trim();
    if (pn.isEmpty) {
      throw Exception("Invalid sortablePropName. Not allow empty");
    }
    String sign = "";
    String propName = pn;
    if (pn.startsWith("+") || pn.startsWith("-")) {
      sign = pn.substring(0, 1);
      propName = pn.substring(1).trim();
    }
    if (propName.isEmpty) {
      throw Exception("Invalid sortablePropName. '$sortablePropName'. "
          "Valid example: 'email', '+email' or '-email'");
    }
    return _SignAndPropName(sign: sign, propName: propName);
  }
}

abstract class BlockComparator<ITEM extends Object> {
  final List<String> _nonSignedPropNames = [];
  final List<_SignAndPropName> _signAndPropNames = [];

  ///
  /// ```dart
  /// List<String> sortablePropNames = ["userName", "+email", "-fullName"];
  ///
  /// var myBlockComparator = MyBlockComparator(
  ///    sortablePropNames: sortablePropNames,
  /// );
  /// ```
  ///
  BlockComparator({
    required List<String> sortablePropNames,
  }) {
    if (sortablePropNames.isEmpty) {
      throw Exception("Invalid sortablePropNames. Not Allow Empty");
    }
    for (String sortablePropName in sortablePropNames) {
      _SignAndPropName sapn = _SignAndPropName.parse(sortablePropName);
      //
      _nonSignedPropNames.add(sapn.propName);
      _signAndPropNames.add(sapn);
    }
  }

  ///
  /// ```dart
  /// myBlockComparator.setSortCriteria(
  ///   shuffledSortablePropNames: ['email', '+userName','-fullName'],
  /// );
  /// ```
  ///
  void setSortCriteria({
    required List<String> shuffledSortablePropNames,
  }) {
    if (shuffledSortablePropNames.length != _nonSignedPropNames.length) {
      throw Exception(
          "Invalid shuffledSignedPropNames. Length must be ${_nonSignedPropNames.length}");
    }
    //
    final List<_SignAndPropName> newSignAndPropNames = [];
    for (String sortablePropName in shuffledSortablePropNames) {
      _SignAndPropName sapn = _SignAndPropName.parse(sortablePropName);
      //
      if (!_nonSignedPropNames.contains(sapn.propName)) {
        throw Exception(
            "Invalid propName '${sapn.propName}' (Must be in $_nonSignedPropNames)");
      }
      newSignAndPropNames.add(sapn);
    }
    _signAndPropNames
      ..clear()
      ..addAll(newSignAndPropNames);
  }

  int _compare(ITEM a, ITEM b) {
    for (_SignAndPropName sapn in _signAndPropNames) {
      if (!sapn.isAsc() && !sapn.isDesc()) {
        continue;
      }
      dynamic aValue = getValue(item: a, propName: sapn.propName);
      dynamic bValue = getValue(item: b, propName: sapn.propName);
      //
      if (aValue == null && bValue == null) {
        continue;
      } else if (aValue != null) {
        return sapn.isAsc() ? -1 : 1;
      } else if (bValue != null) {
        return sapn.isAsc() ? 1 : -1;
      }
      // int value
      if (aValue is int) {
        bValue as int;
        int x = aValue - bValue;
        if (x == 0) {
          continue;
        }
        return sapn.isAsc() ? x : -x;
      }
      // double value
      else if (aValue is double) {
        bValue as double;
        int x = aValue - bValue > 0 ? 1 : -1;
        if (x == 0) {
          continue;
        }
        return sapn.isAsc() ? x : -x;
      } else if (aValue is bool) {
        bValue as bool;
        int va = aValue ? 1 : 0;
        int vb = bValue ? 1 : 0;
        int x = va - vb;
        if (x == 0) {
          continue;
        }
        return sapn.isAsc() ? x : -x;
      } else if (aValue is String) {
        bValue as String;
        int x = aValue.compareTo(bValue);
        if (x == 0) {
          continue;
        }
        return sapn.isAsc() ? x : -x;
      } else {
        throw Exception(
            "Method BlockComparator.getValue(item,propName) must be return int, double, bool, null or String");
      }
    }
    return 0;
  }

  ///
  /// Return type must be int, double, bool, null or String.
  ///
  dynamic getValue({required ITEM item, required String propName});
}
