part of '../flutter_artist.dart';

enum SortSign {
  plus,
  minus,
  none;

  static SortSign fromSign(String sign) {
    for (SortSign ss in SortSign.values) {
      if (ss.sign == sign) {
        return ss;
      }
    }
    return SortSign.none;
  }
}

extension SortSignExt on SortSign {
  String get sign {
    switch (this) {
      case SortSign.plus:
        return "+";
      case SortSign.minus:
        return "-";
      case SortSign.none:
        return "";
    }
  }
}

class _SignAndPropName {
  SortSign sortSign;
  String propName;

  _SignAndPropName({
    required this.sortSign,
    required this.propName,
  });

  void _setToNone() {
    sortSign = SortSign.none;
  }

  bool isAsc() {
    return sortSign == SortSign.plus;
  }

  bool isDesc() {
    return sortSign == SortSign.minus;
  }

  _SignAndPropName copyWith(SortSign sign) {
    return _SignAndPropName(sortSign: sign, propName: propName);
  }

  SortSign getNextSign() {
    switch (sortSign) {
      case SortSign.plus:
        return SortSign.minus;
      case SortSign.minus:
        return SortSign.none;
      case SortSign.none:
        return SortSign.plus;
    }
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
    //
    SortSign sortSign = SortSign.fromSign(sign);
    return _SignAndPropName(sortSign: sortSign, propName: propName);
  }

  @override
  String toString() {
    return "${sortSign.sign}$propName";
  }
}

abstract class BlockItemComparator<ITEM extends Object> {
  final bool multiOptions;
  final List<String> _nonSignedPropNames = [];
  final List<_SignAndPropName> _signAndPropNames = [];
  final Map<String, _SignAndPropName> _signAndPropNamesMap = {};

  ///
  /// ```dart
  /// List<String> sortablePropNames = ["userName", "+email", "-fullName"];
  ///
  /// var myBlockComparator = MyBlockComparator(
  ///    sortablePropNames: sortablePropNames,
  /// );
  /// ```
  ///
  BlockItemComparator({
    this.multiOptions = false,
    required List<String> sortablePropNames,
  }) {
    if (sortablePropNames.isEmpty) {
      throw Exception("Invalid sortablePropNames. Not Allow Empty");
    }
    int optCount = 0;
    for (String sortablePropName in sortablePropNames) {
      _SignAndPropName sapn = _SignAndPropName.parse(sortablePropName);
      //
      if (sapn.sortSign != SortSign.none) {
        optCount++;
        if (optCount > 1 && !multiOptions) {
          sapn._setToNone();
        }
      }
      //
      _nonSignedPropNames.add(sapn.propName);
      _signAndPropNames.add(sapn);
      _signAndPropNamesMap[sapn.propName] = sapn;
    }
  }

  void clearOptions() {
    for (var sapn in _signAndPropNames) {
      sapn._setToNone();
    }
  }

  void movePropName({
    required String movingPropName,
    required String destPropName,
  }) {
    _SignAndPropName? moving = _signAndPropNamesMap[movingPropName];
    _SignAndPropName? dest = _signAndPropNamesMap[destPropName];
    if (moving == null || dest == null) {
      return;
    }
    int movingIdx = _signAndPropNames.indexOf(moving);
    int destIdx = _signAndPropNames.indexOf(dest);
    if (movingIdx > destIdx) {
      _signAndPropNames.remove(moving);
      _signAndPropNames.insert(destIdx, moving);
    } else {
      _signAndPropNames.remove(moving);
      _signAndPropNames.insert(destIdx, moving);
    }
  }

  void _updateSignAndPropName(_SignAndPropName updateSapn) {
    var updateSapns = [updateSapn];
    __updateSignAndPropNames(updateSapns);
  }

  void __updateSignAndPropNames(List<_SignAndPropName> updateSapns) {
    final Map<String, _SignAndPropName> copyMap = {..._signAndPropNamesMap};
    //
    int optCount = 0;
    for (_SignAndPropName updateSapn in updateSapns) {
      String propName = updateSapn.propName;
      _SignAndPropName? currentSapn = copyMap.remove(propName);
      if (currentSapn == null) {
        continue;
      }
      //
      if (updateSapn.sortSign != SortSign.none) {
        optCount++;
        if (optCount > 1 && !multiOptions) {
          currentSapn._setToNone();
        } else {
          currentSapn.sortSign = updateSapn.sortSign;
        }
      } else {
        currentSapn.sortSign = updateSapn.sortSign;
      }
      //
      if (optCount >= 1 && !multiOptions) {
        for (_SignAndPropName sapn in copyMap.values) {
          sapn._setToNone();
        }
      }
    }
    //
  }

  ///
  /// ```dart
  /// myBlockComparator.updateSortCriteria(
  ///   shuffledSortablePropNames: ['email', '+userName','-fullName'],
  /// );
  /// ```
  ///
  void updateSortCriteria({
    required List<String> shuffledSortablePropNames,
  }) {
    if (shuffledSortablePropNames.length != _nonSignedPropNames.length) {
      throw Exception(
          "Invalid shuffledSignedPropNames. Length must be ${_nonSignedPropNames.length}");
    }
    //
    final List<_SignAndPropName> updateSignAndPropNames = [];
    for (String sortablePropName in shuffledSortablePropNames) {
      _SignAndPropName sapn = _SignAndPropName.parse(sortablePropName);
      //
      if (!_nonSignedPropNames.contains(sapn.propName)) {
        throw Exception(
            "Invalid propName '${sapn.propName}' (Must be in $_nonSignedPropNames)");
      }
      updateSignAndPropNames.add(sapn);
    }
    //
    __updateSignAndPropNames(updateSignAndPropNames);
  }

  int _compare(ITEM a, ITEM b) {
    for (_SignAndPropName sapn in _signAndPropNames) {
      if (sapn.sortSign == SortSign.none) {
        continue;
      }
      dynamic aValue = getValue(item: a, propName: sapn.propName);
      dynamic bValue = getValue(item: b, propName: sapn.propName);
      //
      if (aValue == null && bValue == null) {
        continue;
      } else if (aValue != null && bValue == null) {
        return sapn.isAsc() ? -1 : 1;
      } else if (aValue == null && bValue != null) {
        return sapn.isAsc() ? 1 : -1;
      }
      // int value
      if (aValue is int) {
        bValue as int;
        //
        int x = aValue - bValue;
        if (x == 0) {
          continue;
        }
        return sapn.isAsc() ? x : -x;
      }
      // double value
      else if (aValue is double) {
        bValue as double;
        //
        int x = aValue - bValue > 0 ? 1 : -1;
        if (x == 0) {
          continue;
        }
        return sapn.isAsc() ? x : -x;
      }
      // bool value
      else if (aValue is bool) {
        bValue as bool;
        //
        int va = aValue ? 1 : 0;
        int vb = bValue ? 1 : 0;
        int x = va - vb;
        if (x == 0) {
          continue;
        }
        return sapn.isAsc() ? x : -x;
      }
      // String value
      else if (aValue is String) {
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
  /// The return type must be int, double, bool, null or String.
  ///
  dynamic getValue({required ITEM item, required String propName});

  @override
  String toString() {
    return "multiOptions: $multiOptions ${_signAndPropNames.toString()}";
  }
}
