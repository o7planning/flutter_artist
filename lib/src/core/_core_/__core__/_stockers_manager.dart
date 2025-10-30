part of '../core.dart';

typedef StockerCreator<S> = S Function();

class _StockersManager {
  // Type: ITM.
  final Map<Type, StockerCreator> __stockerCreatorMap = {};
  final Map<Type, Stocker> _stockerMap = {};

  // ***************************************************************************
  // ***************************************************************************

  _StockersManager();

  // ***************************************************************************
  // ***************************************************************************

  void _registerStocker<F extends Stocker<Object, Identifiable<Object>>>(
    StockerCreator<F> builder,
  ) {
    F stocker = builder();
    Type itmType = stocker.getItmType();
    __stockerCreatorMap[itmType] = builder;
  }

  Stocker<ID, ITM>
      _findStocker<ID extends Object, ITM extends Identifiable<ID>>({
    required Type itmType,
  }) {
    Stocker? stocker = _stockerMap[itmType];
    if (stocker != null) {
      return stocker as Stocker<ID, ITM>;
    }
    StockerCreator? builder = __stockerCreatorMap[itmType];
    if (builder == null) {
      String error = DebugUtils.getFatalError(
          " ERROR: No Stocker found for item type $itmType. You need to call:\n "
          " FlutterArtist.storage.registerStocker(() => YourStocker())");
      print(error);
      throw AppError(
        errorMessage:
            "No Stocker found for itm type $itmType. @see console for more details.",
      );
    }
    try {
      print(
        "FLUTTER ARTIST DEBUG >>>>>>>>>>>>>>> create Stocker for itm type: $itmType",
      );
      stocker = builder();
      _stockerMap[itmType] = stocker!;
      return stocker as Stocker<ID, ITM>;
    } catch (e, stackTrace) {
      print(stackTrace);
      throw AppError(
        errorMessage: "Create Stocker error $e. @see console for more details.",
      );
    }
  }
}
