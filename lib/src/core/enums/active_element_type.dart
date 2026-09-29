part of '_enums.dart';

enum ActiveElementType {
  block,
  item,
  scalar,
  task,
  prozess,
  stage;

  String shortInf() {
    switch (this) {
      case ActiveElementType.block:
        return "B";
      case ActiveElementType.item:
        return "I";
      case ActiveElementType.scalar:
        return "S";
      case ActiveElementType.task:
        return "T";
      case ActiveElementType.prozess:
        return "P";
      case ActiveElementType.stage:
        return "S";
    }
  }
}
