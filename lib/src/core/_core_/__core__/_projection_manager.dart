part of '../core.dart';

class _ProjectionManager {
  final _Storage storage;

  bool _ready = false;

  final Map<String, ProjectionFamily> _nameToFamilyMap = {};
  final Map<Type, ProjectionFamily> _typeToFamilyMap = {};

  _ProjectionManager(this.storage);

  // ***************************************************************************

  void _init({
    required ExecutionTrace executionTrace,
    required List<ProjectionFamily> projectionFamilies,
  }) {
    if (_ready) {
      return;
    }
    //
    for (ProjectionFamily family in projectionFamilies) {
      family._checkMembers();
      //
      if (_nameToFamilyMap.containsKey(family.familyName)) {
        String htmlMessage =
            "Duplicate <b>ProjectionFamily</b>(<b>'${family.familyName}</b>).";
        String errorMessage = HtmlUtils.removeTags(htmlMessage);
        //
        executionTrace._addTraceStep(
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
        ProjectionFamily? family2 = _typeToFamilyMap[type];
        if (family2 != null) {
          String htmlMessage =
              "The <b>$type</b> data type is already in <b>$family2</b>.\n"
              "It cannot be registered as a member of <b>$family</b>.";
          String errorMessage = HtmlUtils.removeTags(htmlMessage);
          //
          executionTrace._addTraceStep(
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
    // Valid alls:
    for (ProjectionFamily family in projectionFamilies) {
      String info = "<b>${family.familyName}</b> - ${family._members}";
      FlutterArtist.debugRegister._addDebugRegisterProjection(info);
    }
    //
    _ready = true;
  }

  // ***************************************************************************

  ProjectionFamily? findProjectionFamilyByType({
    required Type type,
  }) {
    return _typeToFamilyMap[type];
  }

  ProjectionFamily? findProjectionFamilyByName({
    required String familyName,
  }) {
    return _nameToFamilyMap[familyName];
  }

  // ***************************************************************************

  Set<Event> getProjectionEvents(Set<Event> originEvents) {
    final Set<Type> polyTypes = {};
    for (Event event in originEvents) {
      polyTypes.add(event.dataType);
      final ProjectionFamily? family =
          findProjectionFamilyByType(type: event.dataType);
      if (family == null) {
        continue;
      }
      polyTypes.addAll(family._members);
    }
    return polyTypes.map((type) => Event(type)).toSet();
  }
}
