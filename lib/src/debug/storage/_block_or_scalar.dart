import 'package:equatable/equatable.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_data_state.dart';
import '../../core/utils/_class_utils.dart';

class BlockOrScalar extends Equatable {
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
      return block!.getFilterInputType().toString();
    } else {
      return scalar!.getFilterInputType().toString();
    }
  }

  String getFilterCriteriaTypeAsString() {
    if (block != null) {
      return block!.getFilterCriteriaType().toString();
    } else {
      return scalar!.getFilterCriteriaType().toString();
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
      return block!
          .registeredOrDefaultFilterModel.debugClassParametersDefinition;
    } else {
      return scalar!
          .registeredOrDefaultFilterModel.debugClassParametersDefinition;
    }
  }

  String get blockOrScalarClassParametersDefinition {
    if (block != null) {
      return block!.debugClassParametersDefinition;
    } else {
      return scalar!.debugClassParametersDefinition;
    }
  }

  String get blockOrScalarClassDefinition {
    if (block != null) {
      return block!.debugClassDefinition;
    } else {
      return scalar!.debugClassDefinition;
    }
  }

  DataState get dataState {
    if (block != null) {
      return block!.dataState;
    } else {
      return scalar!.dataState;
    }
  }

  List<Type> getListenItemTypes() {
    if (block != null) {
      return block!.getOutsideDataTypesToListen();
    } else {
      return scalar!.getOutsideDataTypesToListen();
    }
  }

  // TODO-Rename
  List<String> getListenItemTypesAsStrings() {
    if (block != null) {
      return block!
          .getOutsideDataTypesToListen()
          .map((type) => type.toString())
          .toList();
    } else {
      return scalar!
          .getOutsideDataTypesToListen()
          .map((type) => type.toString())
          .toList();
    }
  }

  const BlockOrScalar.block(this.block) : scalar = null;

  const BlockOrScalar.scalar(this.scalar) : block = null;

  bool hasActiveUIComponent() {
    if (block != null) {
      return block!.ui.hasActiveUIComponent();
    } else {
      return scalar!.ui.hasActiveUIComponent();
    }
  }

  @override
  List<Object?> get props => [block?.name, scalar?.name];
}
