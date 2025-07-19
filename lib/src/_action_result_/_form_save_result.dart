part of '../../flutter_artist.dart';

class FormSaveResult extends ActionResult {
  final BlockFormSavingPrecheck? precheck;

  FormSaveResult({this.precheck});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return true;
  }
}
