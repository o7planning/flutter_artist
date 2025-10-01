import 'package:flutter/material.dart';

import '../_core_/core.dart';

@immutable
class EmptyFilterCriteria extends FilterCriteria {
  const EmptyFilterCriteria();

  @override
  List<String> getDebugInfos() {
    return [];
  }

  @override
  List<Object?> get props => [];
}
