part of '../../flutter_artist.dart';

class _FatalAppException extends AppException {
  _FatalAppException({
    required super.message,
    super.details,
  });
}

// class _FormPropCycleError {
//   final String propName1;
//   final String propName2;
//
//   _FormPropCycleError({
//     required this.propName1,
//     required this.propName2,
//   });
// }
//
// class _FilterCriterionCycleError {
//   final String criterionName1;
//   final String criterionName2;
//
//   _FilterCriterionCycleError({
//     required this.criterionName1,
//     required this.criterionName2,
//   });
// }
