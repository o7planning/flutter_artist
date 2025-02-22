part of '../flutter_artist.dart';

abstract class ExtraFormInput {
  FormAction formAction = FormAction.create;

  ExtraFormInput();
}

// -----------------------------------------------------------------------------

class EmptyExtraFormInput extends ExtraFormInput {
  //
}

// -----------------------------------------------------------------------------
