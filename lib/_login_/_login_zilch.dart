part of '../flutter_artist.dart';

class LoginZilch<USER extends ILoggedInUser> extends Zilch {
  LoginZilch({
    required super.name,
  });

  @override
  Future<ApiResult<USER>> callApiQuery(
      {required EmptyFilterCriteria? filterCriteria}) {
    // TODO: implement callApiQuery
    throw UnimplementedError();
  }
}
