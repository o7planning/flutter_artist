import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

class FilterCriterionTypeMismatchError {
  final String tildeCriterionName;
  final Type definedTildeCriterionType;
  final dynamic actualValue;

  FilterCriterionTypeMismatchError({
    required this.tildeCriterionName,
    required this.definedTildeCriterionType,
    required this.actualValue,
  });

  AppError toAppError({required dynamic filterModelName}) {
    return AppError(
      errorMessage:
          "The data type of `$tildeCriterionName` does not match between the definition and the actual type. "
          "Defined as `${getTypeNameWithoutGenerics(definedTildeCriterionType)}`, "
          "actually `${getTypeNameWithoutGenerics(actualValue.runtimeType)}`. "
          "Check `$filterModelName` and its `FilterPanel` for details.",
    );
  }
}

class FilterMultiOptMsMismatchError {
  final String tildeCriterionName;
  final Type definedTildeCriterionType;
  final dynamic actualValue;

  FilterMultiOptMsMismatchError({
    required this.tildeCriterionName,
    required this.definedTildeCriterionType,
    required this.actualValue,
  });

  AppError toAppError({required dynamic filterModelName}) {
    return AppError(
      errorMessage:
          "The input field type of `$tildeCriterionName` does not match between the definition and the actual type. "
          "Defined as `Multi Selection`, but is actually `Single Selection` or something else. "
          "Check `$filterModelName` and its `FilterPanel` for details.",
    );
  }
}

abstract class FilterCriterionRegisterError {
  //
}

class FilterFieldNoConverterError extends FilterCriterionRegisterError {
  final String criterionBaseName;
  final Type dataType;

  FilterFieldNoConverterError({
    required this.criterionBaseName,
    required this.dataType,
  });
}

class DuplicateFilterCriterionError extends FilterCriterionRegisterError {
  final String criterionBaseName;
  final String filterCriteriaClassName;

  DuplicateFilterCriterionError({
    required this.criterionBaseName,
    required this.filterCriteriaClassName,
  });
}

class DuplicateFilterFieldError extends FilterCriterionRegisterError {
  final String field;
  final String filterCriteriaClassName;

  DuplicateFilterFieldError({
    required this.field,
    required this.filterCriteriaClassName,
  });
}

class DuplicateCriterionDefError extends FilterCriterionRegisterError {
  final String criterionBaseName;

  DuplicateCriterionDefError({required this.criterionBaseName});
}

class DuplicateCriterionFieldDefError extends FilterCriterionRegisterError {
  final String criterionBaseName;
  final String fieldName;

  DuplicateCriterionFieldDefError({
    required this.criterionBaseName,
    required this.fieldName,
  });
}

// ????
class TildeCriterionConfigInvalidSuffixError
    extends FilterCriterionRegisterError {
  final String criterionBaseName;
  final String tildeSuffix;

  TildeCriterionConfigInvalidSuffixError({
    required this.tildeSuffix,
    required this.criterionBaseName,
  });
}

// ????
class TildeCriterionConfigDuplicationError
    extends FilterCriterionRegisterError {
  final String criterionBaseName;
  final String tildeSuffix;

  TildeCriterionConfigDuplicationError({
    required this.tildeSuffix,
    required this.criterionBaseName,
  });
}

class DuplicateFilterConditionDefError extends FilterCriterionRegisterError {
  final String tildeCriterionName;
  final String? groupName;

  DuplicateFilterConditionDefError({
    required this.tildeCriterionName,
    required this.groupName,
  });

  @override
  String toString() {
    return "Duplicated ConditionDef Criterion Name Tilde: $tildeCriterionName";
  }
}

class DuplicateConditionGroupDefError extends FilterCriterionRegisterError {
  final String groupName;

  DuplicateConditionGroupDefError({required this.groupName});

  @override
  String toString() {
    return "Duplicated ConditionGroupDef Group Name: $groupName";
  }
}

class FilterCriterionNotFoundError extends FilterCriterionRegisterError {
  final String criterionBaseName;
  final String tildeCriterionName;

  FilterCriterionNotFoundError({
    required this.criterionBaseName,
    required this.tildeCriterionName,
  });

  @override
  String toString() {
    return "Criterion Name: $criterionBaseName not found!";
  }
}

class TildeCriterionNameError extends FilterCriterionRegisterError {
  final String tildeCriterionName;

  TildeCriterionNameError({required this.tildeCriterionName});

  @override
  String toString() {
    return "Invalid Criterion Name Tilde: $tildeCriterionName";
  }
}

class TildeSuffixError extends FilterCriterionRegisterError {
  final String tildeSuffix;

  TildeSuffixError({required this.tildeSuffix});

  @override
  String toString() {
    return "Invalid Tilde Suffix: $tildeSuffix";
  }
}

class CriterionBaseNameError extends FilterCriterionRegisterError {
  final String criterionBaseName;

  CriterionBaseNameError({required this.criterionBaseName});

  @override
  String toString() {
    return "Invalid Criterion Base Name: $criterionBaseName";
  }
}

class FilterFieldNameError extends FilterCriterionRegisterError {
  final String fieldName;

  FilterFieldNameError({required this.fieldName});

  @override
  String toString() {
    return "Invalid Field Name: $fieldName";
  }
}
