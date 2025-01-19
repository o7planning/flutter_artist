part of '../flutter_artist.dart';

abstract class ExtraInput {
  FormAction formAction = FormAction.create;

  ExtraInput();
}

class EmptyExtraInput extends ExtraInput {
  //
}
