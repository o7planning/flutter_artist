part of '../../flutter_artist.dart';

class SortCriterion {
  final String propName;
  String _text;
  SortingDirection _direction;

  String get text => _text;

  SortingDirection get direction => _direction;

  SortCriterion._({
    required SortingDirection direction,
    required this.propName,
    required String text,
  })  : _text = text,
        _direction = direction;

  bool isAscending() {
    return _direction == SortingDirection.ascending;
  }

  bool isDescending() {
    return _direction == SortingDirection.descending;
  }

  bool isNonDirection() {
    return _direction == SortingDirection.none;
  }

  SortCriterion copyWith({required SortingDirection direction}) {
    return SortCriterion._(
      propName: propName,
      text: text,
      direction: direction,
    );
  }

  SortCriterion copy() {
    return SortCriterion._(
      propName: propName,
      text: text,
      direction: _direction,
    );
  }

  SortingDirection getNextDirection() {
    switch (_direction) {
      case SortingDirection.ascending:
        return SortingDirection.descending;
      case SortingDirection.descending:
        return SortingDirection.none;
      case SortingDirection.none:
        return SortingDirection.ascending;
    }
  }

  static SortCriterion _parse(String sortablePropName) {
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
    SortingDirection direction = SortingDirection.fromSign(sign);
    return SortCriterion._(
      direction: direction,
      propName: propName,
      text: propName,
    );
  }

  @override
  String toString() {
    return "${direction.sign}$propName";
  }
}
