part of '../flutter_artist.dart';

abstract class QuickExtraFormInputAction<
    EXTRA_FORM_INPUT extends ExtraFormInput> extends BaseAction {
  final EXTRA_FORM_INPUT extraFormInput;

  const QuickExtraFormInputAction({
    required this.extraFormInput,
    required super.needToConfirm,
    required super.actionInfo,
  });
}
