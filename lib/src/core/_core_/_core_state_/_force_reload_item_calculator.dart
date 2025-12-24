part of '../core.dart';

_ForceReloadItemState _calculateBlockState({
  required final MasterFlowItem masterFlowItem,
  required final XBlock thisXBlock,
  required final Object? inputCandidateCurrItem,
  required final Object candidateCurrItem,
  required final bool inputForceReloadItem,
  required final bool hasBlockXRepresentative,
  required final bool hasItemXRepresentative,
  required final bool hasFormRepresentative,
  required final NonItemRepresentativeBehavior nonItemRepresentativeBehavior,
  required final UniformItemRefreshMode uniformItemRefreshMode,
  required final CurrentItemSettingType currentItemSettingType,
  required final bool isCandidateCurrentItemInNewQueriedList,
  required final bool currentItemIdChanged,
}) {
  final Block block = thisXBlock.block;
  final FormModel? formModel = block.formModel;
  //
  bool candidateAccepted = inputCandidateCurrItem != null;
  bool retForceReloadItem = false;
  bool retForceReloadForm = false;
  //
  bool forceReloadItem = inputForceReloadItem;
  bool forceReloadForm = false;
  bool hasItemXRepresentativeExt = hasItemXRepresentative;
  bool hasFormRepresentativeExt = hasFormRepresentative;

  if (thisXBlock.xFormModel != null &&
      thisXBlock.xFormModel!.forceTypeForForm == ForceType.force) {
    // Test Case: [43a].
    forceReloadForm = true;
  }
  if (forceReloadForm) {
    return _ForceReloadItemState(
      candidateAccepted: true,
      forceReloadItem: true,
      forceReloadForm: true,
    );
  }
  //
  switch (currentItemSettingType) {
    case CurrentItemSettingType.setAnItemAsCurrentIfNeed:
      break;
    case CurrentItemSettingType.setAnItemAsCurrent:
      hasItemXRepresentativeExt = true;
    case CurrentItemSettingType.setAnItemAsCurrentThenLoadForm:
      hasItemXRepresentativeExt = true;
      hasFormRepresentativeExt = true;
    case CurrentItemSettingType.refresh:
      hasItemXRepresentativeExt = true;
      forceReloadItem = true;
  }

  final bool isSpecialUniformITEM;
  // ITEM == ITEM_DETAIL
  if (block.getItemType() == block.getItemDetailType()) {
    if (uniformItemRefreshMode == UniformItemRefreshMode.always) {
      hasItemXRepresentativeExt = true;
      isSpecialUniformITEM = false;
    } else {
      if (isCandidateCurrentItemInNewQueriedList) {
        // Use if: isCandidateCurrentItemInNewQueriedList && hasItemXRepresentativeExt
        isSpecialUniformITEM = true; // (***)
      } else {
        isSpecialUniformITEM = false;
      }
    }
  } else {
    isSpecialUniformITEM = false;
  }
  //
  if (!hasItemXRepresentative) {
    if (nonItemRepresentativeBehavior ==
        NonItemRepresentativeBehavior.trySetAnItemAsCurrent) {
      hasItemXRepresentativeExt = true;
    }
  }
  //
  // Start:
  //
  masterFlowItem._addLineFlowItem(
    codeId: "A11000",
    shortDesc: "ITM 1: ITEM == ITEM_DETAIL",
  );
  // hasItemXRepresentativeExt
  if (hasItemXRepresentativeExt) {
    masterFlowItem._addLineFlowItem(
      codeId: "A12000",
      shortDesc: "ITM 1.1: @hasItemXRepresentativeExt: <b>true</b>",
    );
    // currentItemIdChanged
    if (currentItemIdChanged) {
      masterFlowItem._addLineFlowItem(
        codeId: "A13000",
        shortDesc: "ITM 1.1.1: @currentItemIdChanged: <b>true</b>",
      );
      // isCandidateCurrentItemInNewQueriedList
      if (isCandidateCurrentItemInNewQueriedList) {
        masterFlowItem._addLineFlowItem(
          codeId: "A14000",
          shortDesc:
              "ITM 1.1.1.1: @isCandidateCurrentItemInNewQueriedList: <b>true</b>",
        );
        // ON hasItemXRepresentativeExt. (1)
        // ON currentItemIdChanged. (2)
        // ON isCandidateCurrentItemInNewQueriedList. (3)
        if (formModel == null) {
          // (1)(2)(3) --> SPECIAL!! (****)
          retForceReloadItem = !isSpecialUniformITEM;
          retForceReloadForm = false;
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A14100",
            shortDesc: "ITM 1.1.1.1.1 Calculated:",
            parameters: {
              "isSpecialUniformITEM": isSpecialUniformITEM,
              "retForceReloadItem": retForceReloadItem,
              "retForceReloadForm": retForceReloadForm,
            },
          );
        }
        // formModel != null && !hasFormRepresentativeExt
        else if (!hasFormRepresentativeExt) {
          // (1)(2)(3) --> SPECIAL!! (****)
          retForceReloadItem = !isSpecialUniformITEM; // Only If (1)&&(3)
          retForceReloadForm = false;
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A14200",
            shortDesc: "ITM 1.1.1.1.2 Calculated:",
            parameters: {
              "isSpecialUniformITEM": isSpecialUniformITEM,
              "retForceReloadItem": retForceReloadItem,
              "retForceReloadForm": retForceReloadForm,
            },
          );
        }
        // ON hasItemXRepresentativeExt. (1)
        // ON currentItemIdChanged. (2)
        // ON isCandidateCurrentItemInNewQueriedList. (3)
        // formModel != null && hasFormRepresentativeExt
        else {
          // (1)(2)(3) --> SPECIAL!! (****)
          retForceReloadItem = !isSpecialUniformITEM; // Only If (1)&&(3)
          // currentItemIdChanged && hasFormRepresentativeExt
          retForceReloadForm = true;
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A14300",
            shortDesc: "ITM 1.1.1.1.3 Calculated:",
            parameters: {
              "isSpecialUniformITEM": isSpecialUniformITEM,
              "retForceReloadItem": retForceReloadItem,
              "retForceReloadForm": retForceReloadForm,
            },
          );
        }
      }
      // !isCandidateCurrentItemInNewQueriedList
      else {
        masterFlowItem._addLineFlowItem(
          codeId: "A17000",
          shortDesc:
              "ITM 1.1.1.2: @isCandidateCurrentItemInNewQueriedList: <b>false</b>",
        );
        // ON hasItemXRepresentativeExt. (1)
        // ON currentItemIdChanged. (2)
        // ON !isCandidateCurrentItemInNewQueriedList. (3)
        if (formModel == null) {
          retForceReloadItem = true; // (2*)
          retForceReloadForm = false;
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A17100",
            shortDesc: "ITM 1.1.1.2.1 Calculated:",
            parameters: {
              "isSpecialUniformITEM": isSpecialUniformITEM,
              "retForceReloadItem": retForceReloadItem,
              "retForceReloadForm": retForceReloadForm,
            },
          );
        }
        // formModel != null && !hasFormRepresentativeExt
        else if (!hasFormRepresentativeExt) {
          retForceReloadItem = true; // (2*)
          retForceReloadForm = false;
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A17200",
            shortDesc: "ITM 1.1.1.2.2 Calculated:",
            parameters: {
              "isSpecialUniformITEM": isSpecialUniformITEM,
              "retForceReloadItem": retForceReloadItem,
              "retForceReloadForm": retForceReloadForm,
            },
          );
        }
        // formModel != null && hasFormRepresentativeExt
        else {
          retForceReloadItem = true; // (2*)
          // retForceReloadItem && hasFormRepresentativeExt
          retForceReloadForm = true;
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A17300",
            shortDesc: "ITM 1.1.1.2.3 Calculated:",
            parameters: {
              "isSpecialUniformITEM": isSpecialUniformITEM,
              "retForceReloadItem": retForceReloadItem,
              "retForceReloadForm": retForceReloadForm,
            },
          );
        }
      }
    }
    // !currentItemIdChanged
    else {
      masterFlowItem._addLineFlowItem(
        codeId: "A21000",
        shortDesc: "ITM 1.1.2: @currentItemIdChanged: $currentItemIdChanged",
      );
      // isCandidateCurrentItemInNewQueriedList
      if (isCandidateCurrentItemInNewQueriedList) {
        masterFlowItem._addLineFlowItem(
          codeId: "A22000",
          shortDesc:
              "ITM 1.1.2.1: @isCandidateCurrentItemInNewQueriedList: <b>true</b>",
        );
        // ON hasItemXRepresentativeExt. (1)
        // ON !currentItemIdChanged. (2) --> currentItemReady before!
        // ON isCandidateCurrentItemInNewQueriedList. (3)
        if (formModel == null) {
          // (1)(2*)(3*) --> SPECIAL!! (****)
          retForceReloadItem = !isSpecialUniformITEM; // Only If (1)&&(3)
          retForceReloadForm = false;
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A22100",
            shortDesc: "ITM 1.1.2.1.1 Calculated:",
            parameters: {
              "isSpecialUniformITEM": isSpecialUniformITEM,
              "retForceReloadItem": retForceReloadItem,
              "retForceReloadForm": retForceReloadForm,
            },
          );
        }
        // formModel != null && !hasFormRepresentativeExt
        else if (!hasFormRepresentativeExt) {
          // (1)(2*)(3*) --> SPECIAL!! (****)
          retForceReloadItem = !isSpecialUniformITEM; // Only If (1)&&(3)
          retForceReloadForm = false;
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A22200",
            shortDesc: "ITM 1.1.2.1.2 Calculated:",
            parameters: {
              "isSpecialUniformITEM": isSpecialUniformITEM,
              "retForceReloadItem": retForceReloadItem,
              "retForceReloadForm": retForceReloadForm,
            },
          );
        }
        // ON hasItemXRepresentativeExt. (1)
        // ON !currentItemIdChanged. (2) --> currentItemReady before!
        // ON isCandidateCurrentItemInNewQueriedList. (3)
        // formModel != null && hasFormRepresentativeExt
        else {
          // (1)(2*)(3*) --> SPECIAL!! (****)
          retForceReloadItem = !isSpecialUniformITEM; // Only If (1)&&(3)
          // isCandidateCurrentItemInNewQueriedList && hasFormRepresentativeExt
          retForceReloadForm = true;
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A22300",
            shortDesc: "ITM 1.1.2.1.3 Calculated:",
            parameters: {
              "isSpecialUniformITEM": isSpecialUniformITEM,
              "retForceReloadItem": retForceReloadItem,
              "retForceReloadForm": retForceReloadForm,
            },
          );
        }
      }
      // !isCandidateCurrentItemInNewQueriedList
      else {
        masterFlowItem._addLineFlowItem(
          codeId: "A25000",
          shortDesc:
              "ITM 1.1.2.2: @isCandidateCurrentItemInNewQueriedList: <b>false</b>",
        );
        // ON hasItemXRepresentativeExt. (1)
        // ON !currentItemIdChanged. (2) --> currentItemReady before!
        // ON !isCandidateCurrentItemInNewQueriedList. (3)
        if (formModel == null) {
          // (2*)(3*)
          retForceReloadItem = false || forceReloadItem;
          retForceReloadForm = false;
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A25100",
            shortDesc: "ITM 1.1.2.2.1 Calculated:",
            parameters: {
              "isSpecialUniformITEM": isSpecialUniformITEM,
              "retForceReloadItem": retForceReloadItem,
              "retForceReloadForm": retForceReloadForm,
            },
          );
        }
        // ON hasItemXRepresentativeExt. (1)
        // ON !currentItemIdChanged. (2) --> currentItemReady before!
        // ON !isCandidateCurrentItemInNewQueriedList. (3)
        // formModel != null && !hasFormRepresentativeExt
        else if (!hasFormRepresentativeExt) {
          // (2*)(3*)
          retForceReloadItem = false || forceReloadItem;
          retForceReloadForm = false;
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A25200",
            shortDesc: "ITM 1.1.2.2.2 Calculated:",
            parameters: {
              "isSpecialUniformITEM": isSpecialUniformITEM,
              "retForceReloadItem": retForceReloadItem,
              "retForceReloadForm": retForceReloadForm,
            },
          );
        }
        // ON hasItemXRepresentativeExt. (1)
        // ON !currentItemIdChanged. (2) --> currentItemReady before!
        // ON !isCandidateCurrentItemInNewQueriedList. (3)
        // formModel != null && hasFormRepresentativeExt
        else {
          masterFlowItem._addLineFlowItem(
            codeId: "A25300",
            shortDesc: "ITM 1.1.2.2.3",
          );
          if (!__isReady(formModel!)) {
            // hasFormRepresentativeExt && !formReady
            retForceReloadForm = true;
            // retForceReloadForm && (2)
            retForceReloadItem = true;
            //
            masterFlowItem._addLineFlowItem(
              codeId: "A25410",
              shortDesc: "ITM 1.1.2.2.3.1 Calculated:",
              parameters: {
                "isSpecialUniformITEM": isSpecialUniformITEM,
                "retForceReloadItem": retForceReloadItem,
                "retForceReloadForm": retForceReloadForm,
              },
            );
          }
          // ON hasItemXRepresentativeExt. (1)
          // ON !currentItemIdChanged. (2) --> currentItemReady before!
          // ON !isCandidateCurrentItemInNewQueriedList. (3)
          // ON hasFormRepresentativeExt
          // ON formModel != null
          // formReady
          else {
            // (2*)(3*)
            retForceReloadItem = false || forceReloadItem;
            // formReady && hasFormRepresentativeExt
            retForceReloadForm = false || retForceReloadItem;
            //
            masterFlowItem._addLineFlowItem(
              codeId: "A25420",
              shortDesc: "ITM 1.1.2.2.3.2 Calculated:",
              parameters: {
                "isSpecialUniformITEM": isSpecialUniformITEM,
                "retForceReloadItem": retForceReloadItem,
                "retForceReloadForm": retForceReloadForm,
              },
            );
          }
        }
      }
    }
  }
  // !hasItemXRepresentativeExt
  else {
    masterFlowItem._addLineFlowItem(
      codeId: "A28000",
      shortDesc: "ITM 1.2: @hasItemXRepresentativeExt: <b>false</b>",
    );
    // currentItemIdChanged
    if (currentItemIdChanged) {
      masterFlowItem._addLineFlowItem(
        codeId: "A29000",
        shortDesc: "ITM 1.2.1: @currentItemIdChanged: $currentItemIdChanged",
      );
      // isCandidateCurrentItemInNewQueriedList
      if (isCandidateCurrentItemInNewQueriedList) {
        masterFlowItem._addLineFlowItem(
          codeId: "A31000",
          shortDesc:
              "ITM 1.2.1.1: @isCandidateCurrentItemInNewQueriedList: <b>true</b>",
        );
        // ON !hasItemXRepresentativeExt. (1)
        // ON currentItemIdChanged. (2)
        // ON isCandidateCurrentItemInNewQueriedList. (3)
        if (formModel == null) {
          // (1*)
          retForceReloadItem = false || forceReloadItem;
          retForceReloadForm = false;
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A31100",
            shortDesc: "ITM 1.2.1.1.1 Calculated:",
            parameters: {
              "isSpecialUniformITEM": isSpecialUniformITEM,
              "retForceReloadItem": retForceReloadItem,
              "retForceReloadForm": retForceReloadForm,
            },
          );
        }
        // formModel != null && !hasFormRepresentativeExt
        else if (!hasFormRepresentativeExt) {
          // (1*)
          retForceReloadItem = false || forceReloadItem;
          retForceReloadForm = false;
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A31200",
            shortDesc: "ITM 1.2.1.1.2 Calculated:",
            parameters: {
              "isSpecialUniformITEM": isSpecialUniformITEM,
              "retForceReloadItem": retForceReloadItem,
              "retForceReloadForm": retForceReloadForm,
            },
          );
        }
        // formModel != null && hasFormRepresentativeExt
        else {
          masterFlowItem._addLineFlowItem(
            codeId: "A31300",
            shortDesc: "ITM 1.2.1.1.3",
          );
          if (!__isReady(formModel!)) {
            // hasFormRepresentativeExt && !formReady
            retForceReloadForm = true;
            // retForceReloadForm && (2-currentItemIdChanged)
            retForceReloadItem = true;
            //
            masterFlowItem._addLineFlowItem(
              codeId: "A31410",
              shortDesc: "ITM 1.2.1.1.3.1 Calculated:",
              parameters: {
                "isSpecialUniformITEM": isSpecialUniformITEM,
                "retForceReloadItem": retForceReloadItem,
                "retForceReloadForm": retForceReloadForm,
              },
            );
          }
          // formReady
          else {
            // formReady && hasFormRepresentativeExt && (2-currentItemIdChanged)
            retForceReloadForm = true;
            // retForceReloadForm && (2-currentItemIdChanged)
            retForceReloadItem = true;
            //
            masterFlowItem._addLineFlowItem(
              codeId: "A31420",
              shortDesc: "ITM 1.2.1.1.3.2 Calculated:",
              parameters: {
                "isSpecialUniformITEM": isSpecialUniformITEM,
                "retForceReloadItem": retForceReloadItem,
                "retForceReloadForm": retForceReloadForm,
              },
            );
          }
        }
      }
      // !isCandidateCurrentItemInNewQueriedList
      else {
        masterFlowItem._addLineFlowItem(
          codeId: "A34000",
          shortDesc:
              "ITM 1.2.1.2: @isCandidateCurrentItemInNewQueriedList: <b>false</b>",
        );
        // ON !hasItemXRepresentativeExt. (1)
        // ON currentItemIdChanged. (2)
        // ON !isCandidateCurrentItemInNewQueriedList. (3)
        if (formModel == null) {
          // (1*)
          retForceReloadItem = false || forceReloadItem;
          retForceReloadForm = false;
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A34100",
            shortDesc: "ITM 1.2.1.2.1 Calculated:",
            parameters: {
              "isSpecialUniformITEM": isSpecialUniformITEM,
              "retForceReloadItem": retForceReloadItem,
              "retForceReloadForm": retForceReloadForm,
            },
          );
        }
        // formModel != null && !hasFormRepresentativeExt
        else if (!hasFormRepresentativeExt) {
          // (1*)
          retForceReloadItem = false || forceReloadItem;
          retForceReloadForm = false;
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A34200",
            shortDesc: "ITM 1.2.1.2.2 Calculated:",
            parameters: {
              "isSpecialUniformITEM": isSpecialUniformITEM,
              "retForceReloadItem": retForceReloadItem,
              "retForceReloadForm": retForceReloadForm,
            },
          );
        }
        // formModel != null && hasFormRepresentativeExt
        else {
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A34300",
            shortDesc: "ITM 1.2.1.2.3",
          );
          if (!__isReady(formModel!)) {
            // hasFormRepresentativeExt && !formReady
            retForceReloadForm = true;
            // retForceReloadForm && (2-currentItemIdChanged)
            retForceReloadItem = true;
            //
            masterFlowItem._addLineFlowItem(
              codeId: "A34410",
              shortDesc: "ITM 1.2.1.2.3.1 Calculated:",
              parameters: {
                "isSpecialUniformITEM": isSpecialUniformITEM,
                "retForceReloadItem": retForceReloadItem,
                "retForceReloadForm": retForceReloadForm,
              },
            );
          }
          // formReady
          else {
            // formReady && hasFormRepresentativeExt && (2-currentItemIdChanged)
            retForceReloadForm = true;
            // retForceReloadForm && (2-currentItemIdChanged)
            retForceReloadItem = true;
            //
            masterFlowItem._addLineFlowItem(
              codeId: "A34420",
              shortDesc: "ITM 1.2.1.2.3.2 Calculated:",
              parameters: {
                "isSpecialUniformITEM": isSpecialUniformITEM,
                "retForceReloadItem": retForceReloadItem,
                "retForceReloadForm": retForceReloadForm,
              },
            );
          }
        }
      }
    }
    // !currentItemIdChanged
    else {
      masterFlowItem._addLineFlowItem(
        codeId: "A37000",
        shortDesc: "ITM 1.2.2: @currentItemIdChanged: $currentItemIdChanged",
      );
      // isCandidateCurrentItemInNewQueriedList
      if (isCandidateCurrentItemInNewQueriedList) {
        masterFlowItem._addLineFlowItem(
          codeId: "A38000",
          shortDesc:
              "ITM 1.2.2.1: @isCandidateCurrentItemInNewQueriedList: <b>true</b>",
        );
        // ON !hasItemXRepresentativeExt. (1)
        // ON !currentItemIdChanged. (2) --> currentItemReady before!
        // ON isCandidateCurrentItemInNewQueriedList. (3)
        if (formModel == null) {
          // (1*)
          retForceReloadItem = false || forceReloadItem;
          retForceReloadForm = false;
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A38100",
            shortDesc: "ITM 1.2.2.1.1 Calculated:",
            parameters: {
              "isSpecialUniformITEM": isSpecialUniformITEM,
              "retForceReloadItem": retForceReloadItem,
              "retForceReloadForm": retForceReloadForm,
            },
          );
        }
        // formModel != null && !hasFormRepresentativeExt
        else if (!hasFormRepresentativeExt) {
          // (1*)
          retForceReloadItem = false || forceReloadItem;
          retForceReloadForm = false;
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A38200",
            shortDesc: "ITM 1.2.2.1.2 Calculated:",
            parameters: {
              "isSpecialUniformITEM": isSpecialUniformITEM,
              "retForceReloadItem": retForceReloadItem,
              "retForceReloadForm": retForceReloadForm,
            },
          );
        }
        // formModel != null && hasFormRepresentativeExt
        else {
          masterFlowItem._addLineFlowItem(
            codeId: "A38300",
            shortDesc: "ITM 1.2.2.1.3",
          );
          if (!__isReady(formModel!)) {
            // hasFormRepresentativeExt && !formReady
            retForceReloadForm = true;
            // retForceReloadForm && (3-isCandidateCurrentItemInNewQueriedList)
            retForceReloadItem = true;
            //
            masterFlowItem._addLineFlowItem(
              codeId: "A38410",
              shortDesc: "ITM 1.2.2.1.3.1 Calculated:",
              parameters: {
                "isSpecialUniformITEM": isSpecialUniformITEM,
                "retForceReloadItem": retForceReloadItem,
                "retForceReloadForm": retForceReloadForm,
              },
            );
          }
          // formReady
          else {
            // formReady && hasFormRepresentativeExt && (3-isCandidateCurrentItemInNewQueriedList)
            retForceReloadForm = true;
            // retForceReloadForm && (3-isCandidateCurrentItemInNewQueriedList)
            retForceReloadItem = true;
            //
            masterFlowItem._addLineFlowItem(
              codeId: "A38420",
              shortDesc: "ITM 1.2.2.1.3.2 Calculated:",
              parameters: {
                "isSpecialUniformITEM": isSpecialUniformITEM,
                "retForceReloadItem": retForceReloadItem,
                "retForceReloadForm": retForceReloadForm,
              },
            );
          }
        }
      }
      // !isCandidateCurrentItemInNewQueriedList
      else {
        masterFlowItem._addLineFlowItem(
          codeId: "A42000",
          shortDesc:
              "ITM 1.2.2.2: @currentItemIdChanged: $currentItemIdChanged",
        );
        // ON !hasItemXRepresentativeExt. (1)
        // ON !currentItemIdChanged. (2) --> currentItemReady before!
        // ON !isCandidateCurrentItemInNewQueriedList. (3)
        if (formModel == null) {
          // (1*)
          retForceReloadItem = false || forceReloadItem;
          retForceReloadForm = false;
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A42100",
            shortDesc: "ITM 1.2.2.2.1 Calculated:",
            parameters: {
              "isSpecialUniformITEM": isSpecialUniformITEM,
              "retForceReloadItem": retForceReloadItem,
              "retForceReloadForm": retForceReloadForm,
            },
          );
        }
        // formModel != null && !hasFormRepresentativeExt
        else if (!hasFormRepresentativeExt) {
          // (1*)
          retForceReloadItem = false || forceReloadItem;
          retForceReloadForm = false;
          //
          masterFlowItem._addLineFlowItem(
            codeId: "A42200",
            shortDesc: "ITM 1.2.2.2.2 Calculated:",
            parameters: {
              "isSpecialUniformITEM": isSpecialUniformITEM,
              "retForceReloadItem": retForceReloadItem,
              "retForceReloadForm": retForceReloadForm,
            },
          );
        }
        // formModel != null && hasFormRepresentativeExt
        else {
          masterFlowItem._addLineFlowItem(
            codeId: "A42300",
            shortDesc: "ITM 1.2.2.2.3",
          );
          if (!__isReady(formModel!)) {
            // hasFormRepresentativeExt && !formReady
            retForceReloadForm = true;
            // retForceReloadForm
            retForceReloadItem = true;
            //
            masterFlowItem._addLineFlowItem(
              codeId: "A42410",
              shortDesc: "ITM 1.2.2.2.3.1 Calculated:",
              parameters: {
                "isSpecialUniformITEM": isSpecialUniformITEM,
                "retForceReloadItem": retForceReloadItem,
                "retForceReloadForm": retForceReloadForm,
              },
            );
          }
          // formReady
          else {
            // (1*)
            retForceReloadItem = false || forceReloadItem;
            // formReady && hasFormRepresentativeExt
            retForceReloadForm = false || retForceReloadItem;
            //
            masterFlowItem._addLineFlowItem(
              codeId: "A42420",
              shortDesc: "ITM 1.2.2.2.3.2 Calculated:",
              parameters: {
                "isSpecialUniformITEM": isSpecialUniformITEM,
                "retForceReloadItem": retForceReloadItem,
                "retForceReloadForm": retForceReloadForm,
              },
            );
          }
        }
      }
    }
  }
  //
  switch (currentItemSettingType) {
    case CurrentItemSettingType.setAnItemAsCurrentIfNeed:
      if (retForceReloadItem != null || retForceReloadForm != null) {
        candidateAccepted = true;
      }
    case CurrentItemSettingType.setAnItemAsCurrent:
    case CurrentItemSettingType.setAnItemAsCurrentThenLoadForm:
    case CurrentItemSettingType.refresh:
      candidateAccepted = true;
  }
  //
  masterFlowItem._addLineFlowItem(
    codeId: "A12800",
    shortDesc: "Calculated:",
    parameters: {
      "candidateAccepted": candidateAccepted,
      "isSpecialUniformITEM": isSpecialUniformITEM,
      "retForceReloadItem": retForceReloadItem,
      "retForceReloadForm": retForceReloadForm,
    },
  );
  //
  return _ForceReloadItemState(
    candidateAccepted: candidateAccepted,
    forceReloadItem: retForceReloadItem,
    forceReloadForm: retForceReloadForm,
  );
}

bool __isReady(FormModel formModel) {
  return formModel.dataState == DataState.ready;
}
