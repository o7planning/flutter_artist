import 'package:flutter/material.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../core/_core_/core.dart';
import '../../core/utils/_class_utils.dart';

// ***************************************************************************
// ***************************************************************************

String __debugObjHtml(Object? obj, bool asHtml) {
  final b1 = asHtml ? "<b>" : "";
  final b2 = asHtml ? "</b>" : "";
  if (obj == null) {
    return "${b1}null${b2}";
  }
  if (obj is String) {
    final max = 64;
    String s;
    if (obj.length < max) {
      s = obj;
    } else {
      s = "${obj.substring(0, max)}...";
    }
    return "${b1}$s${b2}";
  } else if (obj is int) {
    return "${b1}$obj${b2}";
  } else if (obj is double) {
    return "${b1}$obj${b2}";
  } else if (obj is bool) {
    return "${b1}${obj}${b2}";
  } else if (obj is Enum) {
    return "${b1}$obj${b2}";
  } else if (obj is Identifiable) {
    return "${b1}${getClassNameWithoutGenerics(obj)}(${obj.id})${b2}";
  } else if (obj is ILoggedInUser) {
    return "${b1}${getClassNameWithoutGenerics(obj)}(${obj.userName})${b2}";
  } else if (obj is XShelf) {
    return "${b1}${getClassNameWithoutGenerics(obj)}(${obj.shelf.name})${b2}";
  } else if (obj is FormPropModel) {
    return "${b1}${getClassName(obj)}('${obj.propName}')${b2}";
  } else if (obj is FilterCriterionModel) {
    return "${b1}${getClassName(obj)}('${obj.criterionNameTilde}')${b2}";
  } else if (obj is XData) {
    return "${b1}${getClassName(obj)}${b2}";
  } else if (obj is OptValueWrap) {
    return "${b1}${getClassName(obj)}(${obj.values})${b2}";
  } else if (obj is Pageable) {
    return "${b1}${getClassName(obj)}(page: ${obj.page}, pageSize: ${obj.pageSize})${b2}";
  } else if (obj is PageData) {
    int count = obj.items.length;
    return "${b1}${getClassName(obj)}($count items)${b2}";
  } else if (obj is SortableCriteria) {
    return "${b1}${getClassName(obj)}(${obj.toSignedString()})${b2}";
  } else if (obj is List) {
    if (obj is List<Event>) {
      return "${b1}${obj.toString()}${b2}";
    }
    return "${b1}${getClassName(obj)}(${obj.length} items)${b2}";
  } else if (obj is Map) {
    return "${b1}${getClassName(obj)}(${obj.length} entries)${b2}";
  } else if (obj is Function) {
    return "${b1}[Function]${b2}";
  } else if (obj is Locale) {
    return "${b1}${getClassName(obj)}(${obj.languageCode}, ${obj.countryCode})${b2}";
  } else if (obj is Type) {
    return "${b1}$obj${b2}";
  }
  return "${b1}${getClassNameWithoutGenerics(obj)}${b2}";
}

// ***************************************************************************
// ***************************************************************************

String debugObjHtml(Object? obj) {
  return __debugObjHtml(obj, true);
}

String debugObj(Object? obj) {
  return __debugObjHtml(obj, false);
}

// ***************************************************************************
// ***************************************************************************
