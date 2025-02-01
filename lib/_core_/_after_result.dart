part of '../flutter_artist.dart';

class _DeleteResult<ITEM> {
  final bool success;
  final ITEM? sibling;

  _DeleteResult({
    required this.success,
    required this.sibling,
  });
}
