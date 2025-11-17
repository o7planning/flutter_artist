part of '../core.dart';

typedef StockerCreator<S> = S Function();

class _StockersManager {
  // Type: ITM.
  final Map<Type, StockerCreator> __stockerCreatorMap = {};
  final Map<Type, AutoStocker> _stockerMap = {};

  // ***************************************************************************
  // ***************************************************************************

  _StockersManager();

  // ***************************************************************************
  // ***************************************************************************

  void
      _registerAutoStocker<F extends AutoStocker<Object, Identifiable<Object>>>(
    StockerCreator<F> builder,
  ) {
    F stocker = builder();
    Type itmType = stocker.getItemType();
    __stockerCreatorMap[itmType] = builder;
  }

  AutoStocker<ID, ITM>
      _findStocker<ID extends Object, ITM extends Identifiable<ID>>({
    required Type itmType,
  }) {
    AutoStocker? stocker = _stockerMap[itmType];
    if (stocker != null) {
      return stocker as AutoStocker<ID, ITM>;
    }
    StockerCreator? builder = __stockerCreatorMap[itmType];
    if (builder == null) {
      String error = DebugUtils.getFatalError(
          " ERROR: No Stocker found for item type $itmType. You need to call:\n "
          " FlutterArtist.storage.registerStocker(() => YourStocker())");
      print(error);
      throw AppError(
        errorMessage:
            "No Stocker found for $itmType. @see console for more details.",
      );
    }
    try {
      DebugPrinter.printDebug(
        DebugCat.autoStockerCreation,
        "FLUTTER ARTIST DEBUG >>>>>>>>>>>>>>> create AutoStocker for $itmType",
      );
      stocker = builder();
      _stockerMap[itmType] = stocker!;
      return stocker as AutoStocker<ID, ITM>;
    } catch (e, stackTrace) {
      print(stackTrace);
      throw AppError(
        errorMessage: "Create Stocker error $e. @see console for more details.",
      );
    }
  }
}
