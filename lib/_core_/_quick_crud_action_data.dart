part of '../flutter_artist.dart';

abstract class QuickCRUDActionData extends BaseActionData {
  const QuickCRUDActionData({
    required super.needToConfirm,
    required super.actionInfo,
  });
}
