enum ActiveElementType {
  block,
  item,
  scalar;

  String shortInf() {
    switch (this) {
      case ActiveElementType.block:
        return "B";
      case ActiveElementType.item:
        return "I";
      case ActiveElementType.scalar:
        return "S";
    }
  }
}