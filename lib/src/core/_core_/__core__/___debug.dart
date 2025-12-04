part of '../core.dart';

// ***************************************************************************
// ***************************************************************************

String _debugUserHtml(ILoggedInUser? user) {
  if (user == null) {
    return "null";
  }
  return "<b>${getClassNameWithoutGenerics(user)}(${user.userName})</b>";
}

// ***************************************************************************
// ***************************************************************************

String _debugObjHtml(Object? obj) {
  if (obj == null) {
    return "null";
  }
  if (obj is Identifiable) {
    return "<b>${getClassNameWithoutGenerics(obj)}(${obj.id})</b>";
  } else if (obj is ILoggedInUser) {
    return "<b>${getClassNameWithoutGenerics(obj)}(${obj.userName})</b>";
  } else if (obj is XShelf) {
    return "<b>${getClassNameWithoutGenerics(obj)}(${obj.shelf.name})</b>";
  } else if (obj is FormProp) {
    return "<b>${getClassNameWithoutGenerics(obj)}(${obj.propName})</b>";
  } else if (obj is FilterCriterion) {
    return "<b>${getClassNameWithoutGenerics(obj)}(${obj.criterionName})</b>";
  } else if (obj is OptValueWrap) {
    return "<b>${getClassNameWithoutGenerics(obj)}(${obj.values})</b>";
  }
  return "<b>${getClassNameWithoutGenerics(obj)}</b>";
}

// ***************************************************************************
// ***************************************************************************

String _debugTypeHtml(Type type) {
  return "<b>${getTypeNameWithoutGenerics(type)}</b>";
}

// ***************************************************************************
// ***************************************************************************
