part of '../../flutter_artist.dart';

class BlockQueryResult extends ActionResult {
  bool _otherError = false;
  bool _filterError = false;
  bool _apiError = false;

  BlockQueryResult();

  @override
  bool get success {
    return !_filterError && !_apiError && !_otherError;
  }
}
