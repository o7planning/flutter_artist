part of '../core.dart';

class _PolymorphismManager {
  final _Storage storage;

  bool _ready = false;

  final Map<String, PolymorphismFamily> _nameToFamilyMap = {};
  final Map<Type, PolymorphismFamily> _typeToFamilyMap = {};

  _PolymorphismManager(this.storage);

  // ***************************************************************************

  void _init({
    required MasterFlowItem masterFlowItem,
    required List<PolymorphismFamily> polymorphismFamilies,
  }) {
    if (_ready) {
      return;
    }
    //
    for (PolymorphismFamily family in polymorphismFamilies) {
      family._checkMembers();
      //
      if (_nameToFamilyMap.containsKey(family.familyName)) {
        String htmlMessage =
            "Duplicate <b>PolymorphismFamily</b>(<b>'${family.familyName}</b>).";
        String errorMessage = HtmlUtils.removeTags(htmlMessage);
        //
        masterFlowItem._addLineFlowItem(
          codeId: "#SP010",
          shortDesc: htmlMessage,
          errorInfo: ErrorInfo(
            errorMessage: errorMessage,
            errorDetails: null,
            stackTrace: null,
          ),
        );
        throw _createFatalAppError(errorMessage);
      }
      _nameToFamilyMap[family.familyName] = family;
      //
      for (Type type in family.members) {
        PolymorphismFamily? family2 = _typeToFamilyMap[type];
        if (family2 != null) {
          String htmlMessage =
              "The <b>$type</b> data type is already in <b>$family2</b>.\n"
              "It cannot be registered as a member of <b>$family</b>.";
          String errorMessage = HtmlUtils.removeTags(htmlMessage);
          //
          masterFlowItem._addLineFlowItem(
            codeId: "#SP030",
            shortDesc: htmlMessage,
            errorInfo: ErrorInfo(
              errorMessage: errorMessage,
              errorDetails: null,
              stackTrace: null,
            ),
          );
          throw _createFatalAppError(errorMessage);
        }
        _typeToFamilyMap[type] = family;
      }
    }
    _ready = true;
  }

  // ***************************************************************************

  PolymorphismFamily? findPolymorphismFamilyByType({
    required Type type,
  }) {
    return _typeToFamilyMap[type];
  }

  PolymorphismFamily? findPolymorphismFamilyByName({
    required String familyName,
  }) {
    return _nameToFamilyMap[familyName];
  }
}
