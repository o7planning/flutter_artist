part of '../core.dart';

_ForceReloadFormState _calculateFormState({
  required XFormModel xFormModel,
  required CurrentItemSelectionType currentItemSelectionType,
  required bool isCandidateCurrentItemInNewQueriedList,
  required bool currentItemChanged,
  required final forceReloadItem,
}) {
  final XBlock thisXBlock = xFormModel.xBlock;
  final Block block = thisXBlock.block;
  final FormModel formModel = xFormModel.formModel;

  bool forceReloadForm = false;

  DebugPrinter.printDebug(DebugCat.dataLoad,
      "@~~~> ${getClassName(block)} ~~~~~> FRM #: currentItemSelectionType: ${currentItemSelectionType.name}");
  //
  if (thisXBlock.xFormModel!.forceTypeForForm == ForceType.force) {
    DebugPrinter.printDebug(DebugCat.dataLoad,
        "@~~~> ${getClassName(block)} ~~~~~> FRM #.1: forceTypeForForm: ${thisXBlock.xFormModel!.forceTypeForForm}");
    // Test Case: [43a].
    forceReloadForm = true;
  }
  // forceTypeForForm != force
  else {
    DebugPrinter.printDebug(DebugCat.dataLoad,
        "@~~~> ${getClassName(block)} ~~~~~> FRM #.2: forceTypeForForm: ${thisXBlock.xFormModel!.forceTypeForForm}");
  }
  //
  final bool formLoadTimeUIActive = formModel.ui.hasActiveUIComponent();
  formModel._loadTimeUIActive = formLoadTimeUIActive;
  //
  if (!forceReloadForm) {
    switch (currentItemSelectionType) {
      /* ---------------------------------------------------------------------*/
      case CurrentItemSelectionType.doNothing:
        DebugPrinter.printDebug(DebugCat.dataLoad,
            "@~~~> ${getClassName(block)} ~~~~~> FRM 0: currentItemSelectionType: ${currentItemSelectionType.name}");
        //
        // ITEM == ITEM_DETAIL.
        //
        if (block.getItemType() == block.getItemDetailType()) {
          DebugPrinter.printDebug(DebugCat.dataLoad,
              "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1: ITEM == ITEM_DETAIL");
          // Just Queried:
          if (isCandidateCurrentItemInNewQueriedList) {
            DebugPrinter.printDebug(DebugCat.dataLoad,
                "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1.1: isCandidateCurrentItemInNewQueriedList: TRUE");
            //
            if (currentItemChanged) {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1.1.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1.1.1.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 0.1.1.1.1",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                //
                forceReloadForm = false; // (**??**)
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1.1.1.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 0.1.1.1.2",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                //
                forceReloadForm = false;
              }
            }
            // !currentItemChanged
            else {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1.1.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1.1.2.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 0.1.1.2.1",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                //
                forceReloadForm = false; // (**??**)
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1.1.2.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 0.1.1.2.2",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                //
                forceReloadForm = false;
              }
            }
          }
          // !isCandidateCurrentItemInNewQueriedList
          else {
            DebugPrinter.printDebug(DebugCat.dataLoad,
                "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1.2: isCandidateCurrentItemInNewQueriedList: FALSE");
            //
            if (currentItemChanged) {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1.2.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1.2.1.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 0.1.2.1.1",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                //
                forceReloadForm = false; // (**??**)
              }
              // !formLoadTimeUIActive.
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1.2.1.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 0.1.2.1.2",
                  shelf: block.shelf,
                  currentShelfCodes: "43a",
                );
                // Test Cases: [43a] - _test_false1_categoryScreen_refreshCategory_3_prodREADY_curr0_form0
                forceReloadForm = false;
              }
            }
            // !currentItemChanged
            else {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1.2.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1.2.2.1: formLoadTimeUIActive: TRUE");
                //
                if (forceReloadItem) {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1.2.2.1.1: forceLoadItem: TRUE");
                  // Debug:
                  _addDebugForceReload(
                    debugCode: "FRM 0.1.2.2.1.1",
                    shelf: block.shelf,
                    currentShelfCodes: "",
                  );
                  //
                  forceReloadForm = false; // (**??**)
                }
                // !forceLoadItem
                else {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1.2.2.1.2: forceLoadItem: FALSE");
                  //
                  if (formModel.dataState != DataState.ready) {
                    DebugPrinter.printDebug(DebugCat.dataLoad,
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1.2.2.1.2.1: formDataState: NOT READY - ${formModel.dataState}");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 0.1.2.2.1.2.1",
                      shelf: block.shelf,
                      currentShelfCodes: "",
                    );
                    //
                    forceReloadForm = false; // (**??**)
                  }
                  // formModel.dataState == DataState.ready
                  else {
                    DebugPrinter.printDebug(DebugCat.dataLoad,
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1.2.2.1.2.2: formLoadTimeUIActive: READY");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 0.1.2.2.1.2.2",
                      shelf: block.shelf,
                      currentShelfCodes: "43a",
                    );
                    // Test Cases: [43a] - _test_false1_categoryScreen_refreshCategory_2_prodREADY_curr1_form0
                    forceReloadForm = false;
                  }
                }
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1.2.2.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 0.1.2.2.2",
                  shelf: block.shelf,
                  currentShelfCodes: "43a",
                );
                // Test Cases: [43a] - _test_false1_categoryScreen_refreshCategory_2_prodREADY_curr1_form0
                forceReloadForm = false;
              }
            }
          }
        }
        // ITEM != ITEM_DETAIL:
        else {
          DebugPrinter.printDebug(DebugCat.dataLoad,
              "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2: ITEM != ITEM_DETAIL");
          // Just Queried:
          if (isCandidateCurrentItemInNewQueriedList) {
            DebugPrinter.printDebug(DebugCat.dataLoad,
                "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2.1: isCandidateCurrentItemInNewQueriedList: TRUE");
            //
            if (currentItemChanged) {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2.1.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2.1.1.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 0.2.1.1.1",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                //
                forceReloadForm = false; // (**??**)
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2.1.1.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 0.2.1.1.2",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                //
                forceReloadForm = false;
              }
            }
            // !currentItemChanged
            else {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2.1.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2.1.2.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 0.2.1.2.1",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                //
                forceReloadForm = false; // (**??**)
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2.1.2.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 0.2.1.2.2",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                //
                forceReloadForm = false;
              }
            }
          }
          // !isCandidateCurrentItemInNewQueriedList
          else {
            DebugPrinter.printDebug(DebugCat.dataLoad,
                "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2.2: isCandidateCurrentItemInNewQueriedList: FALSE");
            //
            if (currentItemChanged) {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2.2.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2.2.1.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 0.2.2.1.1",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                //
                forceReloadForm = false; // (**??**)
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2.2.1.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 0.2.2.1.2",
                  shelf: block.shelf,
                  currentShelfCodes: "43a",
                );
                // Test Cases: [44a] - _test_false1_productScreen_refreshCategory_1
                forceReloadForm = false;
              }
            }
            // !currentItemChanged
            else {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2.2.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2.2.2.1: formLoadTimeUIActive: TRUE");
                //
                if (forceReloadItem) {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2.2.2.1.1: forceReloadItem: TRUE");
                  // Debug:
                  _addDebugForceReload(
                    debugCode: "FRM 0.2.2.2.1.1",
                    shelf: block.shelf,
                    currentShelfCodes: "",
                  );
                  //
                  forceReloadForm = false; // (**??**)
                }
                // !forceReloadItem
                else {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2.2.2.1.2: forceReloadItem: FALSE");
                  //
                  if (formModel.dataState != DataState.ready) {
                    DebugPrinter.printDebug(DebugCat.dataLoad,
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2.2.2.1.2.1: formDataState: NOT READY - ${formModel.dataState}");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 0.2.2.2.1.2.1",
                      shelf: block.shelf,
                      currentShelfCodes: "",
                    );
                    //
                    forceReloadForm = false; // (**??**)
                  }
                  // formModel.dataState == ready.
                  else {
                    DebugPrinter.printDebug(DebugCat.dataLoad,
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2.2.2.1.2.2: formDataState: READY");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 0.2.2.2.1.2.2",
                      shelf: block.shelf,
                      currentShelfCodes: "43a",
                    );
                    // Test Cases: [44a] -  _test_false1_productScreen_refreshCategory_1
                    forceReloadForm = false;
                  }
                }
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2.2.2.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 0.2.2.2.2",
                  shelf: block.shelf,
                  currentShelfCodes: "43a",
                );
                // Test Cases: [44a] - _test_false1_productScreen_refreshCategory_1
                forceReloadForm = false;
              }
            }
          }
        }
      /* ---------------------------------------------------------------------*/
      case CurrentItemSelectionType.setAnItemAsCurrentIfNeed:
        DebugPrinter.printDebug(DebugCat.dataLoad,
            "@~~~> ${getClassName(block)} ~~~~~> FRM 1: currentItemSelectionType: ${currentItemSelectionType.name}");
        //
        // ITEM == ITEM_DETAIL.
        //
        if (block.getItemType() == block.getItemDetailType()) {
          DebugPrinter.printDebug(DebugCat.dataLoad,
              "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1: ITEM == ITEM_DETAIL");
          // Just Queried:
          if (isCandidateCurrentItemInNewQueriedList) {
            DebugPrinter.printDebug(DebugCat.dataLoad,
                "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.1: isCandidateCurrentItemInNewQueriedList: TRUE");
            //
            if (currentItemChanged) {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.1.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.1.1.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.1.1.1.1",
                  shelf: block.shelf,
                  currentShelfCodes: "13a, 42a",
                );
                //
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.1.1.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.1.1.1.2",
                  shelf: block.shelf,
                  currentShelfCodes: "13a, 36c",
                );
                //
                forceReloadForm = false;
              }
            }
            // !currentItemChanged
            else {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.1.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.1.2.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.1.1.2.1",
                  shelf: block.shelf,
                  currentShelfCodes: "13a, 36c",
                );
                //
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.1.2.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.1.1.2.2",
                  shelf: block.shelf,
                  currentShelfCodes: "36c",
                );
                //
                forceReloadForm = false;
              }
            }
          }
          // !isCandidateCurrentItemInNewQueriedList
          else {
            DebugPrinter.printDebug(DebugCat.dataLoad,
                "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.2: isCandidateCurrentItemInNewQueriedList: FALSE");
            //
            if (currentItemChanged) {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.2.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.2.1.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.1.2.1.1",
                  shelf: block.shelf,
                  currentShelfCodes: "13a",
                );
                //
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive.
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.2.1.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.1.2.1.2",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                //
                forceReloadForm = false;
              }
            }
            // !currentItemChanged
            else {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.2.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.2.2.1: formLoadTimeUIActive: TRUE");
                //
                if (forceReloadItem) {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.2.2.1.1: forceLoadItem: TRUE");
                  // Debug:
                  _addDebugForceReload(
                    debugCode: "FRM 1.1.2.2.1.1",
                    shelf: block.shelf,
                    currentShelfCodes: "",
                  );
                  //
                  forceReloadForm = true;
                }
                // !forceLoadItem
                else {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.2.2.1.2: forceLoadItem: FALSE");
                  //
                  if (formModel.dataState != DataState.ready) {
                    DebugPrinter.printDebug(DebugCat.dataLoad,
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.2.2.1.2.1: formDataState: NOT READY - ${formModel.dataState}");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 1.1.2.2.1.2.1",
                      shelf: block.shelf,
                      currentShelfCodes: "36b, 36c",
                    );
                    //
                    forceReloadForm = true;
                  }
                  // formModel.dataState == DataState.ready
                  else {
                    DebugPrinter.printDebug(DebugCat.dataLoad,
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.2.2.1.2.2: formLoadTimeUIActive: READY");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 1.1.2.2.1.2.2",
                      shelf: block.shelf,
                      currentShelfCodes: "13a, 42a",
                    );
                    //
                    forceReloadForm = false;
                  }
                }
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.2.2.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.1.2.2.2",
                  shelf: block.shelf,
                  currentShelfCodes: "43a",
                );
                // Test Cases: [43a] - _test_false1_productScreen_refreshCategory_1
                forceReloadForm = false;
              }
            }
          }
        }
        // ITEM != ITEM_DETAIL:
        else {
          DebugPrinter.printDebug(DebugCat.dataLoad,
              "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2: ITEM != ITEM_DETAIL");
          // Just Queried:
          if (isCandidateCurrentItemInNewQueriedList) {
            DebugPrinter.printDebug(DebugCat.dataLoad,
                "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.1: isCandidateCurrentItemInNewQueriedList: TRUE");
            //
            if (currentItemChanged) {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.1.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.1.1.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.2.1.1.1",
                  shelf: block.shelf,
                  currentShelfCodes:
                      "11a, 11b, 37a, 38a, 38b, 39a, 39b, 40a, 40b",
                );
                //
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.1.1.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.2.1.1.2",
                  shelf: block.shelf,
                  currentShelfCodes:
                      "11a, 36a, 36b, 36c, 37a, 38a, 38b, 39b, 40b, 41a",
                );
                //
                forceReloadForm = false;
              }
            }
            // !currentItemChanged
            else {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.1.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.1.2.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.2.1.2.1",
                  shelf: block.shelf,
                  currentShelfCodes: "39a, 40a",
                );
                //
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.1.2.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.2.1.2.2",
                  shelf: block.shelf,
                  currentShelfCodes: "43a",
                );
                // Test Cases: [43a] -  _test_false1_productScreen_refreshCategory_1
                forceReloadForm = false;
              }
            }
          }
          // !isCandidateCurrentItemInNewQueriedList
          else {
            DebugPrinter.printDebug(DebugCat.dataLoad,
                "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.2: isCandidateCurrentItemInNewQueriedList: FALSE");
            //
            if (currentItemChanged) {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.2.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.2.1.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.2.2.1.1",
                  shelf: block.shelf,
                  currentShelfCodes: "11a, 11b, 37a, 38a, 38b, 39b, 40a, 40b",
                );
                //
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.2.1.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.2.2.1.2",
                  shelf: block.shelf,
                  currentShelfCodes: "36a, 36b, 36c, 37a, 38a, 38b, 40b, 41a",
                );
                //
                forceReloadForm = false;
              }
            }
            // !currentItemChanged
            else {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.2.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.2.2.1: formLoadTimeUIActive: TRUE");
                //
                if (forceReloadItem) {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.2.2.1.1: forceReloadItem: TRUE");
                  // Debug:
                  _addDebugForceReload(
                    debugCode: "FRM 1.2.2.2.1.1",
                    shelf: block.shelf,
                    currentShelfCodes: "11b, 39a, 40a",
                  );
                  //
                  forceReloadForm = true;
                }
                // !forceReloadItem
                else {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.2.2.1.2: forceReloadItem: FALSE");
                  //
                  if (formModel.dataState != DataState.ready) {
                    DebugPrinter.printDebug(DebugCat.dataLoad,
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.2.2.1.2.1: formDataState: NOT READY - ${formModel.dataState}");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 1.2.2.2.1.2.1",
                      shelf: block.shelf,
                      currentShelfCodes: "37a, 38a, 38b, 39b, 40b",
                    );
                    //
                    forceReloadForm = true;
                  }
                  // formModel.dataState == ready.
                  else {
                    DebugPrinter.printDebug(DebugCat.dataLoad,
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.2.2.1.2.2: formDataState: READY");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 1.2.2.2.1.2.2",
                      shelf: block.shelf,
                      currentShelfCodes: "11a, 37a, 38a, 40a, 40b",
                    );
                    //
                    forceReloadForm = false;
                  }
                }
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.2.2.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.2.2.2.2",
                  shelf: block.shelf,
                  currentShelfCodes: "36a, 36b, 36c, 38a, 38b, 40b",
                );
                forceReloadForm = false;
              }
            }
          }
        }
      /* ---------------------------------------------------------------------*/
      case CurrentItemSelectionType.setAnItemAsCurrent:
        DebugPrinter.printDebug(DebugCat.dataLoad,
            "@~~~> ${getClassName(block)} ~~~~~> FRM 2: currentItemSelectionType: ${currentItemSelectionType.name}");
        //
        // ITEM == ITEM_DETAIL.
        //
        if (block.getItemType() == block.getItemDetailType()) {
          DebugPrinter.printDebug(DebugCat.dataLoad,
              "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1: ITEM == ITEM_DETAIL");
          // Just Queried:
          if (isCandidateCurrentItemInNewQueriedList) {
            DebugPrinter.printDebug(DebugCat.dataLoad,
                "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.1: isCandidateCurrentItemInNewQueriedList: TRUE");
            //
            if (currentItemChanged) {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.1.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.1.1.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 2.1.1.1.1",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.1.1.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 2.1.1.1.2",
                  shelf: block.shelf,
                  currentShelfCodes: "36b",
                );
                forceReloadForm = false;
              }
            }
            // !currentItemChanged
            else {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.1.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.1.2.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 2.1.1.2.1",
                  shelf: block.shelf,
                  currentShelfCodes: "36b",
                );
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.1.2.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 2.1.1.2.2",
                  shelf: block.shelf,
                  currentShelfCodes: "36b",
                );
                forceReloadForm = false;
              }
            }
          }
          // !isCandidateCurrentItemInNewQueriedList.
          else {
            DebugPrinter.printDebug(DebugCat.dataLoad,
                "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2: isCandidateCurrentItemInNewQueriedList: FALSE");
            // IN Param: selectAnItemAsCurrent.
            if (currentItemChanged) {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.1.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 2.1.2.1.1",
                  shelf: block.shelf,
                  currentShelfCodes: "13a",
                );
                // Test Cases: [13a] -
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.1.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 2.1.2.1.2",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                forceReloadForm = false;
              }
            }
            // !currentItemChanged
            else {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.2.1: formLoadTimeUIActive: TRUE");
                //
                if (forceReloadItem) {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.2.1.1: forceReloadItem: TRUE");
                  // Debug:
                  _addDebugForceReload(
                    debugCode: "FRM 2.1.2.2.1.1",
                    shelf: block.shelf,
                    currentShelfCodes: "43a",
                  );
                  // Test Case: [43a] - _test_false1_categoryScreen_refreshCategory_1_prodPENDING
                  forceReloadForm = true;
                }
                // !forceReloadItem
                else {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.2.1.2: forceReloadItem: FALSE");
                  //
                  if (formModel.dataState != DataState.ready) {
                    DebugPrinter.printDebug(DebugCat.dataLoad,
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.2.1.2.1: formDataState: NOT READY - ${formModel.dataState}");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 2.1.2.2.1.2.1",
                      shelf: block.shelf,
                      currentShelfCodes: "43a",
                    );
                    // Test Cases: [43a] - _test_false2_productScreen_refreshProduct_1
                    forceReloadForm = true;
                  }
                  // formModel.dataState == ready.
                  else {
                    DebugPrinter.printDebug(DebugCat.dataLoad,
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.2.1.2.2: formDataState: READY");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 2.1.2.2.1.2.2",
                      shelf: block.shelf,
                      currentShelfCodes: "43a",
                    );
                    // Test Case: [43a] - _test_false2_productScreen_refreshProduct_1
                    forceReloadForm = false;
                  }
                }
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.2.3: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 2.1.2.2.3",
                  shelf: block.shelf,
                  currentShelfCodes: "43a",
                );
                // Test Case: [43a] - _false1_categoryScreen_refreshProduct_1_prodREADY_curr1_form0
                forceReloadForm = false;
              }
            }
          }
        }
        // ITEM != ITEM_DETAIL
        else {
          DebugPrinter.printDebug(DebugCat.dataLoad,
              "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2: ITEM != ITEM_DETAIL");
          // Just Queried:
          if (isCandidateCurrentItemInNewQueriedList) {
            DebugPrinter.printDebug(DebugCat.dataLoad,
                "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.1: isCandidateCurrentItemInNewQueriedList: TRUE");
            //
            if (currentItemChanged) {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.1.1: currentItemChanged: TRUE");
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.1.1.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 2.2.1.1.1",
                  shelf: block.shelf,
                  currentShelfCodes: "39b, 40a, 40b",
                );
                // [39a]
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.1.1.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 2.2.1.1.2",
                  shelf: block.shelf,
                  currentShelfCodes: "39b",
                );
                // [39b]
                forceReloadForm = false;
              }
            }
            // !currentItemChanged
            else {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.1.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.1.2.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 2.2.1.2.1",
                  shelf: block.shelf,
                  currentShelfCodes: "39a",
                );
                // [39a]
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.1.2.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 2.2.1.2.2",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                // [39b]
                forceReloadForm = false;
              }
            }
          }
          // !isCandidateCurrentItemInNewQueriedList
          else {
            DebugPrinter.printDebug(DebugCat.dataLoad,
                "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2: isCandidateCurrentItemInNewQueriedList: FALSE");
            //
            if (currentItemChanged) {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2.1.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 2.2.2.1.1",
                  shelf: block.shelf,
                  currentShelfCodes: "40a",
                );
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2.1.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 2.2.2.1.2",
                  shelf: block.shelf,
                  currentShelfCodes: "40b",
                );
                forceReloadForm = false;
              }
            }
            // !currentItemChanged
            else {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2.2.1: formLoadTimeUIActive: TRUE");
                //
                if (forceReloadItem) {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2.2.1.1: forceReloadItem: TRUE");
                  // Debug:
                  _addDebugForceReload(
                    debugCode: "FRM 2.2.2.2.1.1",
                    shelf: block.shelf,
                    currentShelfCodes: "43a",
                  );
                  // Test Cases: [44a] -  _test_false1_productScreen_refreshCategory_1
                  forceReloadForm = true;
                }
                // !forceReloadItem
                else {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2.2.1.1: forceReloadItem: FALSE");
                  //
                  if (formModel.dataState != DataState.ready) {
                    DebugPrinter.printDebug(DebugCat.dataLoad,
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2.2.1.1.1: formDataState: NOT READY - ${formModel.dataState}");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 2.2.2.2.1.1.1",
                      shelf: block.shelf,
                      currentShelfCodes: "",
                    );
                    forceReloadForm = true;
                  }
                  // formModel.dataState == ready.
                  else {
                    DebugPrinter.printDebug(DebugCat.dataLoad,
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2.2.1.1.2: formDataState: READY");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 2.2.2.2.1.1.2",
                      shelf: block.shelf,
                      currentShelfCodes: "40a, 40b",
                    );
                    forceReloadForm = false;
                  }
                }
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2.2.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 2.2.2.2.2",
                  shelf: block.shelf,
                  currentShelfCodes: "40b",
                );
                //
                forceReloadForm = false;
              }
            }
          }
        }
      /* ---------------------------------------------------------------------*/
      case CurrentItemSelectionType.setAnItemAsCurrentAndLoadForm:
        DebugPrinter.printDebug(DebugCat.dataLoad,
            "@~~~> ${getClassName(block)} ~~~~~> FRM 3: currentItemSelectionType: ${currentItemSelectionType.name}");
        //
        // ITEM == ITEM_DETAIL.
        //
        if (block.getItemType() == block.getItemDetailType()) {
          DebugPrinter.printDebug(DebugCat.dataLoad,
              "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1: ITEM == ITEM_DETAIL");
          // Just Queried:
          if (isCandidateCurrentItemInNewQueriedList) {
            DebugPrinter.printDebug(DebugCat.dataLoad,
                "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.1: isCandidateCurrentItemInNewQueriedList: TRUE");
            //
            if (currentItemChanged) {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.1.1: currentItemChanged: TRUE");
              //
              // IN Param: selectAnItemAsCurrentAndLoadForm
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.1.1.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 3.1.1.1.1",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.1.1.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 3.1.1.1.2",
                  shelf: block.shelf,
                  currentShelfCodes: "36a",
                );
                forceReloadForm = true;
              }
            }
            // !currentItemChanged
            else {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.1.2: currentItemChanged: FALSE");
              //
              // IN Param: selectAnItemAsCurrentAndLoadForm
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.1.2.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 3.1.1.2.1",
                  shelf: block.shelf,
                  currentShelfCodes: "36a",
                );
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.1.2.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 3.1.1.2.2",
                  shelf: block.shelf,
                  currentShelfCodes: "36a",
                );
                forceReloadForm = true;
              }
            }
          }
          // !isCandidateCurrentItemInNewQueriedList
          else {
            DebugPrinter.printDebug(DebugCat.dataLoad,
                "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2: isCandidateCurrentItemInNewQueriedList: FALSE");
            //
            if (currentItemChanged) {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.1: currentItemChanged: TRUE");
              //
              // IN Param: selectAnItemAsCurrentAndLoadForm
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.1.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 3.1.2.1.1",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.1.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 3.1.2.1.2",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                forceReloadForm = true;
              }
            }
            // !currentItemChanged
            else {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.2.1: formLoadTimeUIActive: TRUE");
                //
                if (forceReloadItem) {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.2.1.1: forceReloadItem: TRUE");
                  // Debug:
                  _addDebugForceReload(
                    debugCode: "FRM 3.1.2.2.1.1",
                    shelf: block.shelf,
                    currentShelfCodes: "43a",
                  );
                  // Test Case: [43a] -  _test_false3_productScreen_refreshProduct_1
                  forceReloadForm = true;
                }
                // !forceReloadItem
                else {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.2.1.2: forceReloadItem: FALSE");
                  //
                  if (formModel.dataState != DataState.ready) {
                    DebugPrinter.printDebug(DebugCat.dataLoad,
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.2.1.2.1: formDataState: NOT READY - ${formModel.dataState}");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 3.1.2.2.1.2.1",
                      shelf: block.shelf,
                      currentShelfCodes: "",
                    );
                    forceReloadForm = true;
                  }
                  // formModel.dataState == ready.
                  else {
                    DebugPrinter.printDebug(DebugCat.dataLoad,
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.2.1.2.2: formDataState: READY");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 3.1.2.2.1.2.2",
                      shelf: block.shelf,
                      currentShelfCodes: "",
                    );
                    // Test Case: [43a].
                    forceReloadForm = false;
                  }
                }
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.2.2: formLoadTimeUIActive: FALSE");
                //
                if (formModel.dataState != DataState.ready) {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.2.2.1: formDataState: NOT READY - ${formModel.dataState}");
                  // Debug:
                  _addDebugForceReload(
                    debugCode: "FRM 3.1.2.2.2.1",
                    shelf: block.shelf,
                    currentShelfCodes: "",
                  );
                  // Test Case: [43a]
                  forceReloadForm = false;
                }
                // formModel.dataState == ready.
                else {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.2.2.2: formDataState: READY");
                  // Debug:
                  _addDebugForceReload(
                    debugCode: "FRM 3.1.2.2.2.2",
                    shelf: block.shelf,
                    currentShelfCodes: "",
                  );
                  // Test Case: [43a].
                  forceReloadForm = false;
                }
              }
            }
          }
        }
        // ITEM != ITEM_DETAIL
        else {
          DebugPrinter.printDebug(DebugCat.dataLoad,
              "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2: ITEM != ITEM_DETAIL");
          // Just Queried:
          if (isCandidateCurrentItemInNewQueriedList) {
            DebugPrinter.printDebug(DebugCat.dataLoad,
                "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.1: isCandidateCurrentItemInNewQueriedList: TRUE");
            //
            if (currentItemChanged) {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.1.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.1.1.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 3.2.1.1.1",
                  shelf: block.shelf,
                  currentShelfCodes: "39b, 40a, 40b",
                );
                // [39a]
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.1.1.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 3.2.1.1.2",
                  shelf: block.shelf,
                  currentShelfCodes: "39b, 40b",
                );
                // [39b]
                forceReloadForm = true;
              }
            }
            // !currentItemChanged
            else {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.1.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.1.2.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 3.2.1.2.1",
                  shelf: block.shelf,
                  currentShelfCodes: "39a",
                );
                // [39a]
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.1.2.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 3.2.1.2.2",
                  shelf: block.shelf,
                  currentShelfCodes: "43a",
                );
                // Test Cases: [44a] - _test_false1_productScreen_refreshCategory_1
                forceReloadForm = true;
              }
            }
          }
          // !isCandidateCurrentItemInNewQueriedList
          else {
            DebugPrinter.printDebug(DebugCat.dataLoad,
                "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2: isCandidateCurrentItemInNewQueriedList: FALSE");
            //
            if (currentItemChanged) {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.1: currentItemChanged: TRUE");
              // (*** IN Param: selectAnItemAsCurrentAndLoadForm)
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.1.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 3.2.2.1.1",
                  shelf: block.shelf,
                  currentShelfCodes: "40a",
                );
                forceReloadForm = true;
              }
              // (*** IN Param: selectAnItemAsCurrentAndLoadForm)
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.1.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 3.2.2.1.2",
                  shelf: block.shelf,
                  currentShelfCodes: "40b",
                );
                //
                forceReloadForm = true;
              }
            }
            // !currentItemChanged
            else {
              DebugPrinter.printDebug(DebugCat.dataLoad,
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.2: currentItemChanged: FALSE");
              // (*** IN Param: selectAnItemAsCurrentAndLoadForm)
              if (formLoadTimeUIActive) {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.2.1: formLoadTimeUIActive: TRUE");
                //
                if (forceReloadItem) {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.2.1.1: forceReloadItem: TRUE");
                  // Debug:
                  _addDebugForceReload(
                    debugCode: "FRM 3.2.2.2.1.1",
                    shelf: block.shelf,
                    currentShelfCodes: "",
                  );
                  // Test Case: [44a].
                  forceReloadForm = true;
                }
                // !forceReloadItem
                else {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.2.1.2: forceReloadItem: FALSE");
                  //
                  if (formModel.dataState != DataState.ready) {
                    DebugPrinter.printDebug(DebugCat.dataLoad,
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.2.1.2.1: formDataState: NOT READY - ${formModel.dataState}");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 3.2.2.2.1.2.1",
                      shelf: block.shelf,
                      currentShelfCodes: "",
                    );
                    forceReloadForm = true;
                  }
                  // formModel.dataState == ready.
                  else {
                    DebugPrinter.printDebug(DebugCat.dataLoad,
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.2.1.2.2: formDataState: READY");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 3.2.2.2.1.2.2",
                      shelf: block.shelf,
                      currentShelfCodes: "40a, 40b",
                    );
                    forceReloadForm = false;
                  }
                }
              }
              // !formLoadTimeUIActive
              else {
                DebugPrinter.printDebug(DebugCat.dataLoad,
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.2.2: formLoadTimeUIActive: FALSE");
                //
                if (formModel.dataState != DataState.ready) {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.2.2.1: formDataState: NOT READY - ${formModel.dataState}");
                  // Debug:
                  _addDebugForceReload(
                    debugCode: "FRM 3.2.2.2.2.1",
                    shelf: block.shelf,
                    currentShelfCodes: "",
                  );
                  forceReloadForm = true;
                }
                // formModel.dataState == ready.
                else {
                  DebugPrinter.printDebug(DebugCat.dataLoad,
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.2.2.2: formDataState: READY");
                  // Debug:
                  _addDebugForceReload(
                    debugCode: "FRM 3.2.2.2.2.2",
                    shelf: block.shelf,
                    currentShelfCodes: "40b",
                  );
                  forceReloadForm = false;
                }
              }
            }
          }
        }
      /* ---------------------------------------------------------------------*/
      case CurrentItemSelectionType.refresh:
        throw UnimplementedError();
    }
  }
  //
  bool newForceReloadItem = forceReloadItem;
  if (forceReloadForm) {
    newForceReloadItem = true;
  }

  return _ForceReloadFormState(
    forceReloadItem: newForceReloadItem,
    forceReloadForm: forceReloadForm,
  );
}
