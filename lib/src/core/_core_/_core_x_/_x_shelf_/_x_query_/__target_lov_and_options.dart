part of '../../../core.dart';

class TargetLovAndOptions {
  final LovModel lovModel;
  final QueryType queryType;
  final ListUpdateStrategy? listUpdateStrategy;
  final Pageable? pageable;

  TargetLovAndOptions({
    required this.lovModel,
    required this.queryType,
    required this.listUpdateStrategy,
    required this.pageable,
  });
}
