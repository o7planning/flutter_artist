part of '../flutter_artist.dart';

abstract class ExtraFormInput {
  //
}

class EmptyExtraFormData extends ExtraFormInput {
  //
}

abstract class SuggestedFormData {
  FormAction formAction = FormAction.create;

  SuggestedFormData();
}
