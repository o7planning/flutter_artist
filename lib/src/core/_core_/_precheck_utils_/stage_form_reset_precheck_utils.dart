part of '__precheck_utils.dart';

/// Utility class providing standalone precheck validation for resetting
/// a [StageFormModel].
class StageFormResetPrecheckUtils {
  /// Evaluates whether the stage form can be reset to its initial state.
  static Actionable<StageFormResetPrecheck> checkBeforeResetForm({
    required bool checkBusy,
    required bool isBusy,
    required int? targetStageOrder,
    required int? viewingStageOrder,
    required bool hasForm,
    required StageDataState targetStageDataState,
    required FormDataState? targetFormDataState,
    required bool isDirty,
    required bool checkAllow,
    required CheckAllowResult Function() checkFormResetAllowed,
  }) {
    if (checkBusy && isBusy) {
      return Actionable.no(
        errCode: StageFormResetPrecheck.busy,
      );
    }

    if (targetStageOrder == null || viewingStageOrder == null) {
      return Actionable.no(
        errCode: StageFormResetPrecheck.noViewingStage,
      );
    }

    if (targetStageOrder != viewingStageOrder) {
      return Actionable.no(
        errCode: StageFormResetPrecheck.isNotViewingStage,
      );
    }

    if (!hasForm) {
      return Actionable.no(
        errCode: StageFormResetPrecheck.noForm,
      );
    }

    if (targetStageDataState.isNone ||
        targetStageDataState.isPending ||
        targetStageDataState.isLoadedStale) {
      return Actionable.no(
        errCode: StageFormResetPrecheck.stageNotReady,
      );
    }

    if (targetFormDataState == null || !targetFormDataState.isLoadedFresh) {
      return Actionable.no(
        errCode: StageFormResetPrecheck.formDataNotLoaded,
      );
    }

    if (!isDirty) {
      return Actionable.no(
        errCode: StageFormResetPrecheck.formIsNotDirty,
      );
    }

    if (checkAllow) {
      final CheckAllowResult allowResult = checkFormResetAllowed();
      if (allowResult.isError) {
        return Actionable.no(
          errCode: StageFormResetPrecheck.checkAllowMethodError,
          errorInfo: allowResult.errorInfo,
        );
      }
      if (!allowResult.isAllowed) {
        return Actionable.no(
          errCode: StageFormResetPrecheck.notAllowed,
        );
      }
    }

    return Actionable.yes();
  }
}
