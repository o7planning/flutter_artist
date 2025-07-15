part of '../../flutter_artist.dart';

class ScalarQueryResult extends ActionResult {
  bool _filterError = false;
  bool _apiError = false;

  @override
  bool get success {
    return !_filterError && !_apiError;
  }
}
