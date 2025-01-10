part of '../flutter_artist.dart';

enum FormAction {
  create,
  edit;
}

abstract class SuggestedFormData {
  FormAction _formAction = FormAction.create;

  FormAction get formAction => _formAction;

  SuggestedFormData();
}
