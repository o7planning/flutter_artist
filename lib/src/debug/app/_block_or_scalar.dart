import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_artist_router/flutter_artist_router.dart';

import '../../core/_core_/core.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '../constants/_debug_constants.dart';

class BlockOrScalar extends Equatable {
  final Block? block;
  final Scalar? scalar;

  const BlockOrScalar.block(this.block) : scalar = null;

  const BlockOrScalar.scalar(this.scalar) : block = null;

  String getDataStateName() {
    if (block != null) {
      return block!.dataState.name;
    } else {
      return scalar!.dataState.name;
    }
  }

  Color getBgColor(BuildContext context) {
    if (block != null) {
      return switch (block!.dataState) {
        BlockDataStatePending() =>
          DebugConstants.graphBoxDataStatePendingBgColor(context),
        BlockDataStateLoaded() =>
          DebugConstants.graphBoxDataStateReadyBgColor(context),
        BlockDataStateNone() =>
          DebugConstants.graphBoxDataStateNoneBgColor(context),
      };
    } else {
      return switch (scalar!.dataState) {
        ScalarDataStatePending() =>
          DebugConstants.graphBoxDataStatePendingBgColor(context),
        ScalarDataStateLoaded() =>
          DebugConstants.graphBoxDataStateReadyBgColor(context),
        ScalarDataStateNone() =>
          DebugConstants.graphBoxDataStateNoneBgColor(context),
      };
    }
  }

  IconData getIconData() {
    if (block != null) {
      return switch (block!.dataState) {
        BlockDataStatePending() => FaIconConstants.dataStatePendingIconData,
        BlockDataStateLoaded() => FaIconConstants.dataStateLoadedIconData,
        BlockDataStateNone() => FaIconConstants.dataStateNoneIconData,
      };
    } else {
      return switch (scalar!.dataState) {
        ScalarDataStatePending() => FaIconConstants.dataStatePendingIconData,
        ScalarDataStateLoaded() => FaIconConstants.dataStateLoadedIconData,
        ScalarDataStateNone() => FaIconConstants.dataStateNoneIconData,
      };
    }
  }

  Set<FaRouteData> get faRoutes {
    if (block != null) {
      return block!.ui.faRouteDatas;
    } else {
      return scalar!.ui.faRouteDatas;
    }
  }

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
      return block!.debug.classParametersDefinition;
    } else {
      return scalar!.debug.classParametersDefinition;
    }
  }

  String get blockOrScalarClassDefinition {
    if (block != null) {
      return block!.debug.classDefinition;
    } else {
      return scalar!.debug.classDefinition;
    }
  }

  FilterCriteria? get filterCriteria {
    if (block != null) {
      return block!.filterCriteria;
    } else {
      return scalar!.filterCriteria;
    }
  }

  bool hasActiveUiComponent() {
    if (block != null) {
      return block!.ui.hasActiveUiComponent();
    } else {
      return scalar!.ui.hasActiveUiComponent();
    }
  }

  @override
  List<Object?> get props => [block?.name, scalar?.name];
}
