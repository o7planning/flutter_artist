part of '../../flutter_artist.dart';

class BlockQueryResult extends ActionResult {
  bool _noCurrentPageable = false;
  bool _noPreviousPage = false;
  bool _noNextPage = false;
  bool _lockAddMoreQuery = false;
  bool _otherError = false;
  bool _filterError = false;
  bool _apiError = false;

  BlockQueryResult();

  BlockQueryResult.lockAddMoreQuery() : _lockAddMoreQuery = true;

  BlockQueryResult.noCurrentPageable() : _noCurrentPageable = true;

  BlockQueryResult.noPreviousPage() : _noPreviousPage = true;

  BlockQueryResult.noNextPage() : _noNextPage = true;

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
