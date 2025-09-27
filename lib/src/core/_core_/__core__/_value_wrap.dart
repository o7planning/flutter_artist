part of '../core.dart';

class _ValueWrap<VALUE> {
  final String? _id;
  final VALUE? _value;

  _ValueWrap({
    required String? id,
    required VALUE? value,
  })  : _id = id,
        _value = value,
        assert((id == null && value == null) || (id != null && value != null));
}
