part of '_enums.dart';

abstract interface class FormMode {
  String get name;
}

enum InternalFormMode {
  creation,
  edit,
  none,
  compose;

  String get tooltip {
    switch (this) {
      case InternalFormMode.creation:
        return "Creation mode";
      case InternalFormMode.edit:
        return "Edit mode";
      case InternalFormMode.none:
        return "None mode";
      case InternalFormMode.compose:
        return "Compose mode";
    }
  }

  BlockFormMode toBlockFormMode() =>
      switch (this) {
        InternalFormMode.creation => BlockFormMode.creation,
        InternalFormMode.edit => BlockFormMode.edit,
        _ => BlockFormMode.none,
      };

  WorkNodeFormMode toWorkNodeFormMode() =>
      switch (this) {
        InternalFormMode.compose => WorkNodeFormMode.compose,
        _ => WorkNodeFormMode.none,
      };
}

/// Public form mode exposed to [BlockFormModel] consumers.
enum BlockFormMode implements FormMode {
  none,
  creation,
  edit;

  bool get isNone => this == BlockFormMode.none;

  bool get isCreation => this == BlockFormMode.creation;

  bool get isEdit => this == BlockFormMode.edit;

  @override
  String get name {
    switch (this) {
      case BlockFormMode.none:
        return "none";
      case BlockFormMode.creation:
        return "creation";
      case BlockFormMode.edit:
        return "edit";
    }
  }
}

/// Public form mode exposed to [WorkNodeFormModel] ([Task] and [Stage]) consumers.
enum WorkNodeFormMode implements FormMode {
  none,
  compose;

  bool get isNone => this == WorkNodeFormMode.none;

  bool get isCompose => this == WorkNodeFormMode.compose;

  @override
  String get name {
    switch (this) {
      case WorkNodeFormMode.none:
        return "none";
      case WorkNodeFormMode.compose:
        return "compose";
    }
  }
}
