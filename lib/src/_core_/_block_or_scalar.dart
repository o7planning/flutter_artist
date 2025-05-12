part of '../../flutter_artist.dart';

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
      return block!.itemCount;
    } else {
      return scalar!.value == null ? 0 : 1;
    }
  }

  FilterModel? get filterModel {
    if (block != null) {
      return block!.filterModel;
    } else {
      return scalar!.filterModel;
    }
  }

  String getFilterInputTypeAsString() {
    if (block != null) {
      return block!.getFilterInputTypeAsString();
    } else {
      return scalar!.getFilterInputTypeAsString();
    }
  }

  String getFilterCriteriaTypeAsString() {
    if (block != null) {
      return block!.getFilterCriteriaTypeAsString();
    } else {
      return scalar!.getFilterCriteriaTypeAsString();
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

  String get filterClassParametersDefinition {
    if (block != null) {
      return block!._registeredOrDefaultFilterModel._classParametersDefinition;
    } else {
      return scalar!._registeredOrDefaultFilterModel._classParametersDefinition;
    }
  }

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
      return block!.queryDataState;
    } else {
      return scalar!.queryDataState;
    }
  }

  List<Type> get listenItemTypes {
    if (block != null) {
      return block!._getOutsideDataTypesToListen();
    } else {
      return scalar!._getOutsideDataTypesToListen();
    }
  }

  // TODO-Rename
  List<String> get listenItemTypesAsStrings {
    if (block != null) {
      return block!
          ._getOutsideDataTypesToListen()
          .map((type) => type.toString())
          .toList();
    } else {
      return scalar!
          ._getOutsideDataTypesToListen()
          .map((type) => type.toString())
          .toList();
    }
  }

  const _BlockOrScalar.block(this.block) : scalar = null;

  const _BlockOrScalar.scalar(this.scalar) : block = null;

  bool hasActiveUIComponent() {
    if (block != null) {
      return block!.hasActiveUIComponent();
    } else {
      return scalar!.hasActiveUIComponent();
    }
  }

  @override
  List<Object?> get props => [block?.name, scalar?.name];
}
