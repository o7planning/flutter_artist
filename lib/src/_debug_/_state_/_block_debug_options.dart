part of '../../../flutter_artist.dart';

class BlockDebugOptions {
  final bool showLastQueryType;
  final bool showUIActive;
  final bool showQueryDataState;
  final bool showLastQueryResultState;
  final bool showCallApiQueryCount;
  final bool showCallApiRefreshItemCount;
  final bool showItemCount;
  final bool showCurrentItemChangeCount;
  final bool showFilterCriteriaChangeCount;
  final bool showHasCurrentItem;

  const BlockDebugOptions({
    this.showLastQueryType = true,
    this.showUIActive = true,
    this.showQueryDataState = true,
    this.showCallApiQueryCount = true,
    this.showCallApiRefreshItemCount = true,
    this.showItemCount = true,
    this.showCurrentItemChangeCount = true,
    this.showFilterCriteriaChangeCount = true,
    this.showHasCurrentItem = true,
    this.showLastQueryResultState = true,
  });
}
