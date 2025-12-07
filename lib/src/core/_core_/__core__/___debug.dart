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
    return "<b>null</b>";
  }
  if (obj is String) {
    final max = 30;
    String s;
    if (obj.length < max) {
      s = obj;
    } else {
      s = "${obj.substring(0, max)}...";
    }
    return "<b>$s</b>";
  } else if (obj is int) {
    return "<b>$obj</b>";
  } else if (obj is double) {
    return "<b>$obj</b>";
  } else if (obj is bool) {
    return "<b>${obj}</b>";
  } else if (obj is Enum) {
    return "<b>$obj</b>";
  } else if (obj is Identifiable) {
    return "<b>${getClassNameWithoutGenerics(obj)}(${obj.id})</b>";
  } else if (obj is ILoggedInUser) {
    return "<b>${getClassNameWithoutGenerics(obj)}(${obj.userName})</b>";
  } else if (obj is XShelf) {
    return "<b>${getClassNameWithoutGenerics(obj)}(${obj.shelf.name})</b>";
  } else if (obj is FormProp) {
    return "<b>${getClassName(obj)}('${obj.propName}')</b>";
  } else if (obj is FilterCriterion) {
    return "<b>${getClassName(obj)}('${obj.criterionName}')</b>";
  } else if (obj is XData) {
    return "<b>${getClassName(obj)}</b>";
  } else if (obj is OptValueWrap) {
    return "<b>${getClassName(obj)}(${obj.values})</b>";
  } else if (obj is Pageable) {
    return "<b>${getClassName(obj)}(page: ${obj.page}, pageSize: ${obj.pageSize})</b>";
  } else if (obj is PageData) {
    int count = obj.items.length;
    return "<b>${getClassName(obj)}($count items)</b>";
  } else if (obj is SortableCriteria) {
    return "<b>${getClassName(obj)}(${obj.toSignedString()})</b>";
  } else if (obj is List) {
    return "<b>${getClassName(obj)}(${obj.length} items)</b>";
  } else if (obj is Map) {
    return "<b>${getClassName(obj)}(${obj.length} entries)</b>";
  } else if (obj is Function) {
    return "<b>[Function]</b>";
  } else if (obj is Locale) {
    return "<b>${getClassName(obj)}(${obj.languageCode}, ${obj.countryCode})</b>";
  } else if (obj is Type) {
    return "<b>$obj</b>";
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
