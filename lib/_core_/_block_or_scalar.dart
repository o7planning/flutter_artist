part of '../flutter_artist.dart';

class _BlockOrScalar extends Equatable {
  final Block? block;
  final Scalar? scalar;

  Shelf get shelf {
    if (block != null) {
      return block!.shelf;
    } else {
      return scalar!.shelf;
    }
  }

  int get itemCount {
    if (block != null) {
      return block!.data.items.length;
    } else {
      return scalar!.data.data == null ? 0 : 1;
    }
  }

  BlockFilter? get dataFilter {
    if (block != null) {
      return block!.blockFilter;
    } else {
      return scalar!.blockFilter;
    }
  }

  String getFilterSnapshotTypeAsString() {
    if (block != null) {
      return block!.getFilterSnapshotTypeAsString();
    } else {
      return scalar!.getFilterSnapshotTypeAsString();
    }
  }

  String get blockOrScalarClassName {
    if (block != null) {
      return getClassName(block!);
    } else {
      return getClassName(scalar!);
    }
  }

  String? get description {
    if (block != null) {
      return block!.description;
    } else {
      return scalar!.description;
    }
  }

  String get name {
    if (block != null) {
      return block!.name;
    } else {
      return scalar!.name;
    }
  }

  bool get isBlock => block != null;

  bool get isScalar => scalar != null;

  String get blockOrScalarClassParametersDefinition {
    if (block != null) {
      return block!._classParametersDefinition;
    } else {
      return scalar!._classParametersDefinition;
    }
  }

  String get blockOrScalarClassDefinition {
    if (block != null) {
      return block!._classDefinition;
    } else {
      return scalar!._classDefinition;
    }
  }

  DataState get dataState {
    if (block != null) {
      return block!.dataState;
    } else {
      return scalar!.dataState;
    }
  }

  List<Type> get listenItemTypes {
    if (block != null) {
      return block!.listenItemTypes;
    } else {
      return scalar!.listenItemTypes;
    }
  }

  List<String> get listenItemTypesAsStrings {
    if (block != null) {
      return block!.listenItemTypes.map((type) => type.toString()).toList();
    } else {
      return scalar!.listenItemTypes.map((type) => type.toString()).toList();
    }
  }

  const _BlockOrScalar.block(this.block) : scalar = null;

  const _BlockOrScalar.scalar(this.scalar) : block = null;

  bool hasActiveUiComponent() {
    if (block != null) {
      return block!.hasActiveUiComponent();
    } else {
      return scalar!.hasActiveUiComponent();
    }
  }

  @override
  List<Object?> get props => [block?.name, scalar?.name];
}
