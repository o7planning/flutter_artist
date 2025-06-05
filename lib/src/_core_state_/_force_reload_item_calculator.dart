part of '../../flutter_artist.dart';

_ForceReloadItemState _calculateBlockState({
  required _XBlock thisXBlock,
  required bool hasXActiveUI,
  required CurrentItemSelectionType currentItemSelectionType,
  required bool isCandidateCurrentItemInNewQueriedList,
  required bool currentItemChanged,
}) {
  final Block block = thisXBlock.block;
  //
  bool forceReloadItem = false;
  _printDebugState("@~~~> ${getClassName(block)} ~~~~~> ITM 0");
  //
  switch (currentItemSelectionType) {
    case CurrentItemSelectionType.selectAnItemAsCurrentIfNeed:
      _printDebugState(
          "@~~~> ${getClassName(block)} ~~~~~> ITM 1: currentItemSelectionType: ${currentItemSelectionType.name}");
      //
      // ITEM == ITEM_DETAIL.
      //
      if (block.getItemType() == block.getItemDetailType()) {
        _printDebugState(
            "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1: ITEM == ITEM_DETAIL");
        // Just Queried.
        if (isCandidateCurrentItemInNewQueriedList) {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1.1: isCandidateCurrentItemInNewQueriedList: TRUE");
          //
          if (currentItemChanged) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1.1.1: currentItemChanged: TRUE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1.1.1.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 1.1.1.1.1",
                shelf: block.shelf,
                currentShelfCodes: "13a, 42a",
              );
              //
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1.1.1.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 1.1.1.1.2",
                shelf: block.shelf,
                currentShelfCodes: "13a, 36c, 41a",
              );
              //
              forceReloadItem = true;
            }
          }
          // !currentItemChanged
          else {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1.1.2: currentItemChanged: FALSE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1.1.2.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 1.1.1.2.1",
                shelf: block.shelf,
                currentShelfCodes: "13a, 36c, 41a",
              );
              //
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1.1.2.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 1.1.1.2.2",
                shelf: block.shelf,
                currentShelfCodes: "36c, 41a",
              );
              //
              forceReloadItem = true;
            }
          }
        }
        // !isCandidateCurrentItemInNewQueriedList
        else {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1.2: isCandidateCurrentItemInNewQueriedList: FALSE");
          //
          if (currentItemChanged) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1.2.1: currentItemChanged: TRUE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1.2.1.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 1.1.2.1.1",
                shelf: block.shelf,
                currentShelfCodes: "",
              );
              //
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1.2.1.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 1.1.2.1.2",
                shelf: block.shelf,
                currentShelfCodes: "",
              );
              // (43a) !!
              forceReloadItem = false;
            }
          }
          // !currentItemChanged
          else {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1.2.2: currentItemChanged: FALSE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1.2.2.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 1.1.2.2.1",
                shelf: block.shelf,
                currentShelfCodes: "13a, 36b, 36c, 42a",
              );
              //
              forceReloadItem = false;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1.2.2.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 1.1.2.2.2",
                shelf: block.shelf,
                currentShelfCodes: "",
              );
              //
              forceReloadItem = false;
            }
          }
        }
      }
      // ITEM != ITEM_DETAIL
      else {
        _printDebugState(
            "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2: ITEM != ITEM_DETAIL");
        // Just Queried.
        if (isCandidateCurrentItemInNewQueriedList) {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.1: isCandidateCurrentItemInNewQueriedList: TRUE");
          //
          if (currentItemChanged) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.1.1: currentItemChanged: TRUE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.1.1.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 1.2.1.1.1",
                shelf: block.shelf,
                currentShelfCodes:
                    "11a, 11b, 29a, 36a, 36b, 36c, 37a, 38a, 38b, 39a, 39b, 40a, 40b, 41a",
              );
              //
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.1.1.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 1.2.1.1.2",
                shelf: block.shelf,
                currentShelfCodes: "11a, 39b, 40b",
              );
              //
              forceReloadItem = false;
            }
          }
          // !currentItemChanged
          else {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.1.2: currentItemChanged: FALSE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.1.2.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 1.2.1.2.1",
                shelf: block.shelf,
                currentShelfCodes: "29a, 39a, 40a",
              );
              //
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.1.2.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 1.2.1.2.2",
                shelf: block.shelf,
                currentShelfCodes: "",
              );
              //
              forceReloadItem = true;
            }
          }
        }
        // !isCandidateCurrentItemInNewQueriedList
        else {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.2: isCandidateCurrentItemInNewQueriedList: FALSE");
          //
          if (currentItemChanged) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.2.1: currentItemChanged: TRUE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.2.1.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 1.2.2.1.1",
                shelf: block.shelf,
                currentShelfCodes: "11a, 11b, 29a, 37a, 38b, 39b, 40a, 40b",
              );
              //
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.2.1.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 1.2.2.1.2",
                shelf: block.shelf,
                currentShelfCodes: "",
              );
              //
              forceReloadItem = false;
            }
          }
          // !currentItemChanged
          else {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.2.2: currentItemChanged: FALSE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.2.2.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 1.2.2.2.1",
                shelf: block.shelf,
                currentShelfCodes:
                    "11a, 36a, 36b, 36c, 37a, 38a, 38b, 39b, 40a, 40b",
              );
              //
              forceReloadItem = false;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.2.2.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 1.2.2.2.2",
                shelf: block.shelf,
                currentShelfCodes: "38b, 40b",
              );
              //
              forceReloadItem = false;
            }
          }
        }
      }
    case CurrentItemSelectionType.selectAnItemAsCurrent:
      _printDebugState(
          "@~~~> ${getClassName(block)} ~~~~~> ITM 2: currentItemSelectionType: ${currentItemSelectionType.name}");
      //
      // ITEM == ITEM_DETAIL.
      //
      if (block.getItemType() == block.getItemDetailType()) {
        _printDebugState(
            "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1: ITEM == ITEM_DETAIL");
        // Just Queried.
        if (isCandidateCurrentItemInNewQueriedList) {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.1: isCandidateCurrentItemInNewQueriedList: TRUE");
          //
          if (currentItemChanged) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.1.1: currentItemChanged: TRUE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.1.1.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 2.1.1.1.1",
                shelf: block.shelf,
                currentShelfCodes: "",
              );
              //
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.1.1.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 2.1.1.1.2",
                shelf: block.shelf,
                currentShelfCodes: "36b, 41a",
              );
              //
              forceReloadItem = true;
            }
          }
          // !currentItemChanged
          else {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.1.2: currentItemChanged: FALSE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.1.2.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 2.1.1.2.1",
                shelf: block.shelf,
                currentShelfCodes: "36b, 41a",
              );
              //
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.1.2.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 2.1.1.2.2",
                shelf: block.shelf,
                currentShelfCodes: "36b, 41a",
              );
              //
              forceReloadItem = true;
            }
          }
        }
        // !isCandidateCurrentItemInNewQueriedList
        else {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.2: isCandidateCurrentItemInNewQueriedList: FALSE");
          //
          if (currentItemChanged) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.2.1: currentItemChanged: TRUE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.2.1.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 2.1.2.1.1",
                shelf: block.shelf,
                currentShelfCodes: "",
              );
              //
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.2.1.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 2.1.2.1.2",
                shelf: block.shelf,
                currentShelfCodes: "",
              );
              //
              forceReloadItem = true;
            }
          }
          // !currentItemChanged
          else {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.2.2: currentItemChanged: FALSE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.2.2.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 2.1.2.2.1",
                shelf: block.shelf,
                currentShelfCodes: "",
              );
              //
              // Ready selected as current (No need to refresh):
              forceReloadItem = false;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.2.2.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 2.1.2.2.2",
                shelf: block.shelf,
                currentShelfCodes: "",
              );
              //
              // Ready selected as current (No need to refresh):
              forceReloadItem = false;
            }
          }
        }
      }
      // ITEM != ITEM_DETAIL
      else {
        _printDebugState(
            "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2: ITEM != ITEM_DETAIL");
        // Just Queried.
        if (isCandidateCurrentItemInNewQueriedList) {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.1: isCandidateCurrentItemInNewQueriedList: TRUE");
          //
          if (currentItemChanged) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.1.1: currentItemChanged: TRUE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.1.1.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 2.2.1.1.1",
                shelf: block.shelf,
                currentShelfCodes: "39b, 40a, 40b",
              );
              //
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.1.1.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 2.2.1.1.2",
                shelf: block.shelf,
                currentShelfCodes: "39b",
              );
              //
              forceReloadItem = true;
            }
          }
          // !currentItemChanged
          else {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.1.2: currentItemChanged: FALSE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.1.2.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 2.2.1.2.1",
                shelf: block.shelf,
                currentShelfCodes: "39a",
              );
              //
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.1.2.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 2.2.1.2.2",
                shelf: block.shelf,
                currentShelfCodes: "",
              );
              //
              forceReloadItem = true;
            }
          }
        }
        // !isCandidateCurrentItemInNewQueriedList
        else {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.2: isCandidateCurrentItemInNewQueriedList: FALSE");
          //
          if (currentItemChanged) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.2.1: currentItemChanged: TRUE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.2.1.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 2.2.2.1.1",
                shelf: block.shelf,
                currentShelfCodes: "40a",
              );
              //
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.2.1.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 2.2.2.1.2",
                shelf: block.shelf,
                currentShelfCodes: "40b",
              );
              //
              forceReloadItem = true;
            }
          }
          // !currentItemChanged
          else {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.2.2: currentItemChanged: FALSE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.2.2.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 2.2.2.2.1",
                shelf: block.shelf,
                currentShelfCodes: "40a, 40b",
              );
              //
              forceReloadItem = false;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.2.2.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 2.2.2.2.2",
                shelf: block.shelf,
                currentShelfCodes: "40b",
              );
              //
              forceReloadItem = false;
            }
          }
        }
      }
    case CurrentItemSelectionType.selectAnItemAsCurrentAndLoadForm:
      _printDebugState(
          "@~~~> ${getClassName(block)} ~~~~~> ITM 3: currentItemSelectionType: ${currentItemSelectionType.name}");
      //
      // ITEM == ITEM_DETAIL.
      //
      if (block.getItemType() == block.getItemDetailType()) {
        _printDebugState(
            "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1: ITEM == ITEM_DETAIL");
        // Just Queried.
        if (isCandidateCurrentItemInNewQueriedList) {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.1: isCandidateCurrentItemInNewQueriedList: TRUE");
          //
          if (currentItemChanged) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.1.1: currentItemChanged: TRUE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.1.1.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 3.1.1.1.1",
                shelf: block.shelf,
                currentShelfCodes: "",
              );
              //
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.1.1.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 3.1.1.1.2",
                shelf: block.shelf,
                currentShelfCodes: "36a, 41a",
              );
              //
              forceReloadItem = true;
            }
          }
          // !currentItemChanged
          else {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.1.2: currentItemChanged: FALSE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.1.2.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 3.1.1.2.1",
                shelf: block.shelf,
                currentShelfCodes: "36a, 41a",
              );
              //
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.1.2.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 3.1.1.2.2",
                shelf: block.shelf,
                currentShelfCodes: "36a, 41a",
              );
              //
              forceReloadItem = true;
            }
          }
        }
        // !isCandidateCurrentItemInNewQueriedList
        else {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.2: isCandidateCurrentItemInNewQueriedList: FALSE");
          //
          if (currentItemChanged) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.2.1: currentItemChanged: TRUE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.2.1.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 3.1.2.1.1",
                shelf: block.shelf,
                currentShelfCodes: "",
              );
              //
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.2.1.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 3.1.2.1.2",
                shelf: block.shelf,
                currentShelfCodes: "",
              );
              //
              forceReloadItem = true;
            }
          }
          // !currentItemChanged
          else {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.2.2: currentItemChanged: FALSE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.2.2.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 3.1.2.2.1",
                shelf: block.shelf,
                currentShelfCodes: "",
              );
              //
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.2.2.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 3.1.2.2.2",
                shelf: block.shelf,
                currentShelfCodes: "",
              );
              //
              forceReloadItem = true;
            }
          }
        }
      }
      // ITEM != ITEM_DETAIL
      else {
        _printDebugState(
            "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2: ITEM != ITEM_DETAIL");
        // Just Queried.
        if (isCandidateCurrentItemInNewQueriedList) {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.1: isCandidateCurrentItemInNewQueriedList: TRUE");
          //
          if (currentItemChanged) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.1.1: currentItemChanged: TRUE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.1.1.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 3.2.1.1.1",
                shelf: block.shelf,
                currentShelfCodes: "39b, 40a, 40b",
              );
              //
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.1.1.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 3.2.1.1.2",
                shelf: block.shelf,
                currentShelfCodes: "39b, 40b",
              );
              //
              forceReloadItem = true;
            }
          }
          // !currentItemChanged
          else {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.1.2: currentItemChanged: FALSE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.1.2.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 3.2.1.2.1",
                shelf: block.shelf,
                currentShelfCodes: "39a",
              );
              //
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.1.2.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 3.2.1.2.2",
                shelf: block.shelf,
                currentShelfCodes: "",
              );
              //
              forceReloadItem = true;
            }
          }
        }
        // !isCandidateCurrentItemInNewQueriedList
        else {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.2: isCandidateCurrentItemInNewQueriedList: FALSE");
          //
          if (currentItemChanged) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.2.1: currentItemChanged: TRUE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.2.1.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 3.2.2.1.1",
                shelf: block.shelf,
                currentShelfCodes: "40a",
              );
              //
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.2.1.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 3.2.2.1.2",
                shelf: block.shelf,
                currentShelfCodes: "40b",
              );
              //
              forceReloadItem = true;
            }
          }
          // !currentItemChanged
          else {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.2.2: currentItemChanged: FALSE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.2.2.1: hasXActiveUI: TRUE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 3.2.2.2.1",
                shelf: block.shelf,
                currentShelfCodes: "40a, 40b",
              );
              // Ready selected as current (No need to refresh):
              forceReloadItem = false;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.2.2.2: hasXActiveUI: FALSE");
              // Debug:
              _addDebugForceReload(
                debugCode: "ITM 3.2.2.2.2",
                shelf: block.shelf,
                currentShelfCodes: "40b",
              );
              // Ready selected as current (No need to refresh):
              forceReloadItem = false;
            }
          }
        }
      }
    case CurrentItemSelectionType.refresh:
      _printDebugState(
          "@~~~> ${getClassName(block)} ~~~~~> ITM 4: currentItemSelectionType: ${currentItemSelectionType.name}");
      //
      break;
  }
  //
  return _ForceReloadItemState(
    forceReloadItem: forceReloadItem,
  );
}
