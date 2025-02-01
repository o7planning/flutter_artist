part of '../flutter_artist.dart';

class _DeleteResult<ITEM> {
  final bool success;
  final ITEM? sibling;

  _DeleteResult.fail()
      : success = false,
        sibling = null;

  _DeleteResult.success({
    required this.sibling,
  }) : success = true;
}
