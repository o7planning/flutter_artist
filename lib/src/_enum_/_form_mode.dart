part of '../../flutter_artist.dart';

enum FormMode {
  creation,
  edit,
  none;
}

extension FormModeE on FormMode {
  String get tooltip {
    switch (this) {
      case FormMode.creation:
        return "Creation mode";
      case FormMode.edit:
        return "Edit mode";
      case FormMode.none:
        return "None mode";
    }
  }
}
