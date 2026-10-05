part of '../core.dart';

class _ScalarValueWrap<ID, VALUE> {
  final ID? _id;
  final VALUE? _value;

  _ScalarValueWrap({
    required ID? id,
    required VALUE? value,
  })
      : _id = id,
        _value = value,
        assert((id == null && value == null) || (id != null && value != null));
}
