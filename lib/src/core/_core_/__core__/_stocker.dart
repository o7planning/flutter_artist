part of '../core.dart';

abstract class Stocker<ID extends Object, ITM extends Identifiable<ID>> {
  Type getItmIdType() {
    return ID;
  }

  Type getItmType() {
    return ITM;
  }

  Future<ApiResult<ITM>> loadById({required ID id});

  Future<ApiResult<void>> deleteById({required ID id});
}
