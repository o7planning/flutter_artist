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
            if (formLoadTimeUIActive) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.1.1: formLoadTimeUIActive: TRUE");
              //
              if (currentItemChanged) {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.1.1.1: currentItemChanged: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.1.1.1.1",
                  block: block,
                  testCodes: "",
                );
                //
                forceReloadForm = true;
              }
              // !currentItemChanged
              else {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.1.1.2: currentItemChanged: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.1.1.1.2",
                  block: block,
                  testCodes: "",
                );
                //
                forceReloadForm = true;
              }
            } else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.1.2: formLoadTimeUIActive: FALSE");
              //
              if (currentItemChanged) {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.1.2.1: currentItemChanged: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.1.1.2.1",
                  block: block,
                  testCodes: "",
                );
                //
                forceReloadForm = false;
              }
              // !currentItemChanged
              else {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.1.2.2: currentItemChanged: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.1.1.2.2",
                  block: block,
                  testCodes: "",
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
                  block: block,
                  testCodes: "",
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
                  block: block,
                  testCodes: "",
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
                    block: block,
                    testCodes: "",
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
                      block: block,
                      testCodes: "",
                    );
                    //
                    forceReloadForm = true;
                  } else {
                    _printDebugState(
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 1.1.2.2.1.2.2: formLoadTimeUIActive: READY");
                    // Debug:
                    _addDebugForceReload(
                      debugCode: "FRM 1.1.2.2.1.2.2",
                      block: block,
                      testCodes: "",
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
                  block: block,
                  testCodes: "",
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
            if (formLoadTimeUIActive) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.1.1: formLoadTimeUIActive: TRUE");
              //
              if (currentItemChanged) {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.1.1.1: currentItemChanged: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.2.1.1.1",
                  block: block,
                  testCodes: "",
                );
                //
                forceReloadForm = true;
              }
              // !currentItemChanged
              else {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.1.1.2: currentItemChanged: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.2.1.1.2",
                  block: block,
                  testCodes: "",
                );
                //
                forceReloadForm = true;
              }
            }
            // !formLoadTimeUIActive
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.1.2: formLoadTimeUIActive: FALSE");
              //
              if (currentItemChanged) {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.1.2.1: currentItemChanged: TRUE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.2.1.2.1",
                  block: block,
                  testCodes: "",
                );
                //
                forceReloadForm = false;
              }
              // !currentItemChanged
              else {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 1.2.1.2.2: currentItemChanged: FALSE");
                // Debug:
                _addDebugForceReload(
                  debugCode: "FRM 1.2.1.2.2",
                  block: block,
                  testCodes: "",
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
                  block: block,
                  testCodes: "",
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
                  block: block,
                  testCodes: "",
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
                    block: block,
                    testCodes: "",
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
                      block: block,
                      testCodes: "",
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
                      block: block,
                      testCodes: "",
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
                  block: block,
                  testCodes: "",
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
            if (formLoadTimeUIActive) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.1.1: formLoadTimeUIActive: TRUE");
              //
              forceReloadForm = true;
            }
            // !formLoadTimeUIActive
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.1.1: formLoadTimeUIActive: FALSE");
              //
              forceReloadForm = false;
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
                //
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive
              else {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.1.2: formLoadTimeUIActive: FALSE");
                //
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
                    // @@TODO@@ Test.
                    forceReloadForm = true;
                  } else {
                    _printDebugState(
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.2.1.2.2: formDataState: READY");
                    // Test Case: [43a].
                    forceReloadForm = false;
                  }
                }
              }
              // !formLoadTimeUIActive
              else {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.1.2.2.3: formLoadTimeUIActive: FALSE");
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
            if (formLoadTimeUIActive) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.1.1: formLoadTimeUIActive: TRUE");
              // [39a]
              forceReloadForm = true;
            }
            // !formLoadTimeUIActive
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.1.2: formLoadTimeUIActive: FALSE");
              // [39b]
              forceReloadForm = false;
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
                //
                forceReloadForm = true;
              }
              // !formLoadTimeUIActive
              else {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2.1.2: formLoadTimeUIActive: FALSE");
                //
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
                  // Test Case: [44a].
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
                    //
                    forceReloadForm = true;
                  }
                  // formDataState == ready
                  else {
                    _printDebugState(
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2.2.1.1.2: formDataState: READY");
                    //
                    forceReloadForm = false;
                  }
                }
              }
              // !formLoadTimeUIActive
              else {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 2.2.2.2.2: formLoadTimeUIActive: FALSE");
                // Tes Case: [40b] [44a].
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
            //
            // IN Param: selectAnItemAsCurrentAndLoadForm
            //
            if (formLoadTimeUIActive) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.1.1: formLoadTimeUIActive: TRUE");
              //
              forceReloadForm = true;
            } else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.1.2: formLoadTimeUIActive: FALSE");
              //
              forceReloadForm = true;
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
                //
                forceReloadForm = true;
              } else {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.1.2: formLoadTimeUIActive: FALSE");
                //
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
                    // @@TODO@@ Test.
                    forceReloadForm = true;
                  }
                  //
                  else {
                    _printDebugState(
                        "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.2.1.2.2: formDataState: READY");
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
                  // Test Case: [43a]
                  forceReloadForm = false;
                }
                // formDataState = ready.
                else {
                  _printDebugState(
                      "@~~~> ${getClassName(block)} ~~~~~> FRM 3.1.2.2.2.2: formDataState: READY");
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
            if (formLoadTimeUIActive) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.1.1: formLoadTimeUIActive: TRUE");
              // [39a]
              forceReloadForm = true;
            }
            // !formLoadTimeUIActive
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.1.2: formLoadTimeUIActive: TRUE");
              // [39b]
              forceReloadForm = true;
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
                //
                forceReloadForm = true;
              }
              // (*** IN Param: selectAnItemAsCurrentAndLoadForm)
              // formLoadTimeUIActive
              else {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.1.2: formLoadTimeUIActive: FALSE");
                // Test Case: [44a].
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
                    //
                    forceReloadForm = true;
                  }
                  // formDataState == ready.
                  else {
                    forceReloadForm = false;
                  }
                }
              }
              // !formLoadTimeUIActive
              else {
                _printDebugState(
                    "@~~~> ${getClassName(block)} ~~~~~> FRM 3.2.2.2.2: formLoadTimeUIActive: FALSE");
                // @@TODO@@ Test.
                if (formModel.formDataState != DataState.ready) {
                  forceReloadForm = true;
                } else {
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
