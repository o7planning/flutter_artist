part of '../core.dart';

class DialogDeferralResult<V> {
  bool success;
  V? dialogValue;

  DialogDeferralResult.fail() : success = false;

  DialogDeferralResult.success({
    required this.dialogValue,
  }) : success = true;
}
