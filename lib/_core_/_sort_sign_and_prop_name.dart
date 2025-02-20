part of '../flutter_artist.dart';

class _SortSignAndPropName {
  SortSign sortSign;
  String propName;

  _SortSignAndPropName({
    required this.sortSign,
    required this.propName,
  });

  void _setToNone() {
    sortSign = SortSign.none;
  }

  bool isAscending() {
    return sortSign == SortSign.plus;
  }

  bool isDescending() {
    return sortSign == SortSign.minus;
  }

  _SortSignAndPropName copyWith(SortSign sign) {
    return _SortSignAndPropName(sortSign: sign, propName: propName);
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

  static _SortSignAndPropName parse(String sortablePropName) {
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
    return _SortSignAndPropName(sortSign: sortSign, propName: propName);
  }

  @override
  String toString() {
    return "${sortSign.sign}$propName";
  }
}
