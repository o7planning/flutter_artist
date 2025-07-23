part of '../../flutter_artist.dart';

class BlockClearResult extends ActionResult {
  bool _noCurrentPageable = false;
  bool _noPreviousPage = false;
  bool _noNextPage = false;
  bool _lockAddMoreQuery = false;
  bool _otherError = false;
  bool _filterError = false;
  bool _apiError = false;

  BlockClearResult();

  BlockClearResult.lockAddMoreQuery() : _lockAddMoreQuery = true;

  @override
  bool get success {
    return !_noCurrentPageable &&
        !_noPreviousPage &&
        !_noNextPage &&
        !_lockAddMoreQuery &&
        !_filterError &&
        !_apiError &&
        !_otherError;
  }
}
