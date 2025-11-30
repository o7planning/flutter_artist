import 'package:flutter/material.dart';

import '../_core_/core.dart';

// No subclasses allowed.
@immutable
class EmptyFilterCriteria extends FilterCriteria {
  const EmptyFilterCriteria._();

  factory EmptyFilterCriteria() => EmptyFilterCriteria._();

  @override
  List<String> getDebugInfos() {
    return [];
  }

  @override
  List<Object?> get props => [];
}
