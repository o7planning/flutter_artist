part of '../../flutter_artist.dart';

_ForceReloadFormState _calculateFormState({
  required _XFormModel xFormModel,
  required CurrentItemSelectionType currentItemSelectionType,
  required bool isCandidateCurrentItemInNewQueriedList,
  required bool currentItemChanged,
  required final forceReloadItem,
}) {
  final _XBlock thisXBlock = xFormModel.xBlock;
  final Block block = thisXBlock.block;
  final FormModel formModel = xFormModel.formModel;

  bool forceReloadForm = false;

  _printDebugState(
      "@~~~> ${getClassName(block)} ~~~~~> FRM 0: currentItemSelectionType: ${currentItemSelectionType.name}");
  //
  if (thisXBlock.xFormModel!.forceTypeForForm == _ForceType.force) {
    _printDebugState(
        "@~~~> ${getClassName(block)} ~~~~~> FRM 0.1: forceTypeForForm: ${thisXBlock.xFormModel!.forceTypeForForm}");
    // Test Case: [43a].
    forceReloadForm = true;
  } else {
    _printDebugState(
        "@~~~> ${getClassName(block)} ~~~~~> FRM 0.2: forceTypeForForm: ${thisXBlock.xFormModel!.forceTypeForForm}");
  }
  //
  final bool formLoadTimeUIActive = formModel.hasActiveUIComponent();
  formModel._loadTimeUIActive = formLoadTimeUIActive;
  //
  if (!forceReloadForm) {
    final postQueryBehavior = thisXBlock.postQueryBehavior;
    //
    switch (postQueryBehavior) {
      case PostQueryBehavior.clearCurrentItem:
        // Never run.
        break;
      case PostQueryBehavior.createNewItem:
        // Never run.
        break;
      case PostQueryBehavior.selectAnItemAsCurrentIfNeed:
        _printDebugState(
            "@~~~> ${getClassName(block)} ~~~~~> FRM 1: postQueryBehavior: ${postQueryBehavior.name}");
        //
        // ITEM == ITEM_DETAIL.
        //
        if (block.getItemType() == block.getItemDetailType()) {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1: ITEM == ITEM_DETAIL");
          // Just Queried:
          if (isCandidateCurrentItemInNewQueriedList) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.1: isCandidateCurrentItemInNewQueriedList: TRUE");
            //
            if (currentItemChanged) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.1.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
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
                _printDebugState(
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
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.1.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
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
                _printDebugState(
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
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.2: isCandidateCurrentItemInNewQueriedList: FALSE");
            //
            if (currentItemChanged) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.2.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
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
                _printDebugState(
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
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.2.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.2.2.1: formLoadTimeUIActive: TRUE");
                //
                if (forceReloadItem) {
                  _printDebugState(
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
                  _printDebugState(
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.2.2.1.2: forceLoadItem: FALSE");
                  //
                  if (formModel.formDataState != DataState.ready) {
                    _printDebugState(
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.2.2.1.2.1: formDataState: NOT READY - ${formModel.formDataState}");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 1.1.2.2.1.2.1",
                      shelf: block.shelf,
                      currentShelfCodes: "36b, 36c",
                    );
                    //
                    forceReloadForm = true;
                  } else {
                    _printDebugState(
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
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.2.2.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.1.2.2.2",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                //
                forceReloadForm = false;
              }
            }
          }
        }
        // ITEM != ITEM_DETAIL:
        else {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2: ITEM != ITEM_DETAIL");
          // Just Queried:
          if (isCandidateCurrentItemInNewQueriedList) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.1: isCandidateCurrentItemInNewQueriedList: TRUE");
            //
            if (currentItemChanged) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.1.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
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
                _printDebugState(
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
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.1.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
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
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.1.2.2: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.2.1.2.2",
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
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.2: isCandidateCurrentItemInNewQueriedList: FALSE");
            //
            if (currentItemChanged) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.2.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
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
                _printDebugState(
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
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.2.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.2.2.1: formLoadTimeUIActive: TRUE");
                //
                if (forceReloadItem) {
                  _printDebugState(
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
                  _printDebugState(
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.2.2.1.2: forceReloadItem: FALSE");
                  if (formModel.formDataState != DataState.ready) {
                    _printDebugState(
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.2.2.1.2.1: formDataState: NOT READY - ${formModel.formDataState}");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 1.2.2.2.1.2.1",
                      shelf: block.shelf,
                      currentShelfCodes: "37a, 38a, 38b, 39b, 40b",
                    );
                    //
                    forceReloadForm = true;
                  }
                  // formDataState  == ready.
                  else {
                    _printDebugState(
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
                _printDebugState(
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
      case PostQueryBehavior.selectAnItemAsCurrent:
        _printDebugState(
            "@~~~> ${getClassName(block)} ~~~~~> FRM 2: postQueryBehavior: ${postQueryBehavior.name}");
        //
        // ITEM == ITEM_DETAIL.
        //
        if (block.getItemType() == block.getItemDetailType()) {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1: ITEM == ITEM_DETAIL");
          //
          // Just Queried:
          if (isCandidateCurrentItemInNewQueriedList) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.1: isCandidateCurrentItemInNewQueriedList: TRUE");
            //
            if (currentItemChanged) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.1.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
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
                _printDebugState(
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
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.1.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
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
                _printDebugState(
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
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2: isCandidateCurrentItemInNewQueriedList: FALSE");
            // IN Param: selectAnItemAsCurrent.
            if (currentItemChanged) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.1.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 2.1.2.1.1",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive
              else {
                _printDebugState(
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
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.2.1: formLoadTimeUIActive: TRUE");
                //
                if (forceReloadItem) {
                  _printDebugState(
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.2.1.1: forceReloadItem: TRUE");

                  // Debug:
                  _addDebugForceReload(
                    debugCode: "FRM 2.1.2.2.1.1",
                    shelf: block.shelf,
                    currentShelfCodes: "",
                  );

                  // Test Case: [43a].
                  forceReloadForm = true;
                }
                // !forceReloadItem
                else {
                  _printDebugState(
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.2.1.2: forceReloadItem: FALSE");
                  //
                  if (formModel.formDataState != DataState.ready) {
                    _printDebugState(
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.2.1.2.1: formDataState: NOT READY - ${formModel.formDataState}");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 2.1.2.2.1.2.1",
                      shelf: block.shelf,
                      currentShelfCodes: "",
                    );
                    forceReloadForm = true;
                  } else {
                    _printDebugState(
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.2.1.2.2: formDataState: READY");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 2.1.2.2.1.2.2",
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
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.2.3: formLoadTimeUIActive: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 2.1.2.2.3",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                // Test Case: [43a].
                forceReloadForm = false;
              }
            }
          }
        }
        // ITEM != ITEM_DETAIL
        else {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2: ITEM != ITEM_DETAIL");
          //
          // Just Queried:
          if (isCandidateCurrentItemInNewQueriedList) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.1: isCandidateCurrentItemInNewQueriedList: TRUE");
            //
            if (currentItemChanged) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.1.1: currentItemChanged: TRUE");
              if (formLoadTimeUIActive) {
                _printDebugState(
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
                _printDebugState(
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
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.1.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
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
                _printDebugState(
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
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2: isCandidateCurrentItemInNewQueriedList: FALSE");
            //
            //
            if (currentItemChanged) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
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
                _printDebugState(
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
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2.2.1: formLoadTimeUIActive: TRUE");
                //
                if (forceReloadItem) {
                  _printDebugState(
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2.2.1.1: forceReloadItem: TRUE");
                  // Debug:
                  _addDebugForceReload(
                    debugCode: "FRM 2.2.2.2.1.1",
                    shelf: block.shelf,
                    currentShelfCodes: "",
                  );
                  forceReloadForm = true;
                }
                // !forceReloadItem
                else {
                  _printDebugState(
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2.2.1.1: forceReloadItem: FALSE");
                  //
                  if (formModel.formDataState != DataState.ready) {
                    _printDebugState(
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2.2.1.1.1: formDataState: NOT READY - ${formModel.formDataState}");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 2.2.2.2.1.1.1",
                      shelf: block.shelf,
                      currentShelfCodes: "",
                    );
                    forceReloadForm = true;
                  }
                  // formDataState == ready
                  else {
                    _printDebugState(
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
                _printDebugState(
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
      case PostQueryBehavior.selectAnItemAsCurrentAndLoadForm:
        _printDebugState(
            "@~~~> ${getClassName(block)} ~~~~~> FRM 3: postQueryBehavior: ${postQueryBehavior.name}");
        //
        // ITEM == ITEM_DETAIL.
        //
        if (block.getItemType() == block.getItemDetailType()) {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1: ITEM == ITEM_DETAIL");
          //
          // Just Queried:
          if (isCandidateCurrentItemInNewQueriedList) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.1: isCandidateCurrentItemInNewQueriedList: TRUE");
            if (currentItemChanged) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.1.1: currentItemChanged: TRUE");
              //
              // IN Param: selectAnItemAsCurrentAndLoadForm
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.1.1.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 3.1.1.1.1",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                forceReloadForm = true;
              } else {
                _printDebugState(
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
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.1.2: currentItemChanged: FALSE");
              //
              // IN Param: selectAnItemAsCurrentAndLoadForm
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.1.2.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 3.1.1.2.1",
                  shelf: block.shelf,
                  currentShelfCodes: "36a",
                );
                forceReloadForm = true;
              } else {
                _printDebugState(
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
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2: isCandidateCurrentItemInNewQueriedList: FALSE");
            //
            if (currentItemChanged) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.1: currentItemChanged: TRUE");
              //
              // IN Param: selectAnItemAsCurrentAndLoadForm
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.1.1: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 3.1.2.1.1",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                forceReloadForm = true;
              } else {
                _printDebugState(
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
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.2.1: formLoadTimeUIActive: TRUE");
                //
                if (forceReloadItem) {
                  _printDebugState(
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.2.1.1: forceReloadItem: TRUE");
                  // Debug:
                  _addDebugForceReload(
                    debugCode: "FRM 3.1.2.2.1.1",
                    shelf: block.shelf,
                    currentShelfCodes: "",
                  );
                  // Test Case: [43a].
                  forceReloadForm = true;
                }
                // !forceReloadItem
                else {
                  _printDebugState(
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.2.1.2: forceReloadItem: FALSE");
                  //
                  if (formModel.formDataState != DataState.ready) {
                    _printDebugState(
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.2.1.2.1: formDataState: NOT READY - ${formModel.formDataState}");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 3.1.2.2.1.2.1",
                      shelf: block.shelf,
                      currentShelfCodes: "",
                    );
                    forceReloadForm = true;
                  }
                  //
                  else {
                    _printDebugState(
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
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.2.2: formLoadTimeUIActive: FALSE");
                //
                if (formModel.formDataState != DataState.ready) {
                  _printDebugState(
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.2.2.1: formDataState: NOT READY - ${formModel.formDataState}");
                  // Debug:
                  _addDebugForceReload(
                    debugCode: "FRM 3.1.2.2.2.1",
                    shelf: block.shelf,
                    currentShelfCodes: "",
                  );
                  // Test Case: [43a]
                  forceReloadForm = false;
                }
                // formDataState = ready.
                else {
                  _printDebugState(
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
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2: ITEM != ITEM_DETAIL");
          //
          // Just Queried:
          if (isCandidateCurrentItemInNewQueriedList) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.1: isCandidateCurrentItemInNewQueriedList: TRUE");
            //
            if (currentItemChanged) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.1.1: currentItemChanged: TRUE");
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
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
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.1.1.2: formLoadTimeUIActive: TRUE");
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
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.1.2: currentItemChanged: FALSE");
              //
              if (formLoadTimeUIActive) {
                _printDebugState(
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
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.1.2.2: formLoadTimeUIActive: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 3.2.1.2.2",
                  shelf: block.shelf,
                  currentShelfCodes: "",
                );
                // [39b]
                forceReloadForm = true;
              }
            }
          }
          // !isCandidateCurrentItemInNewQueriedList
          else {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2: isCandidateCurrentItemInNewQueriedList: FALSE");
            //
            if (currentItemChanged) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.1: currentItemChanged: TRUE");
              // (*** IN Param: selectAnItemAsCurrentAndLoadForm)
              if (formLoadTimeUIActive) {
                _printDebugState(
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
              // formLoadTimeUIActive
              else {
                _printDebugState(
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
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.2: currentItemChanged: FALSE");
              // (*** IN Param: selectAnItemAsCurrentAndLoadForm)
              if (formLoadTimeUIActive) {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.2.1: formLoadTimeUIActive: TRUE");
                //
                if (forceReloadItem) {
                  _printDebugState(
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
                  _printDebugState(
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.2.1.2: forceReloadItem: FALSE");
                  //
                  if (formModel.formDataState != DataState.ready) {
                    _printDebugState(
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.2.1.2.1: formDataState: NOT READY - ${formModel.formDataState}");

                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 3.2.2.2.1.2.1",
                      shelf: block.shelf,
                      currentShelfCodes: "",
                    );
                    forceReloadForm = true;
                  }
                  // formDataState == ready.
                  else {
                    _printDebugState(
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
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.2.2: formLoadTimeUIActive: FALSE");

                if (formModel.formDataState != DataState.ready) {
                  _printDebugState(
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.2.2.1: formDataState: NOT READY - ${formModel.formDataState}");
                  // Debug:
                  _addDebugForceReload(
                    debugCode: "FRM 3.2.2.2.2.1",
                    shelf: block.shelf,
                    currentShelfCodes: "",
                  );
                  forceReloadForm = true;
                }
                // formDataState == ready.
                else {
                  _printDebugState(
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
