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
      // ITEM == ITEM_DETAIL.
      if (block.getItemType() == block.getItemDetailType()) {
        _printDebugState(
            "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1: ITEM == ITEM_DETAIL");
        //
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
              // Test Cases: @@TODO@@
              forceReloadItem = true;
            } else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1.1.1.2: hasXActiveUI: FALSE");
              // Test Cases: @@TODO@@
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
              // Test Cases: @@TODO@@
              forceReloadItem = true;
            } else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1.1.2.2: hasXActiveUI: FALSE");
              // Test Cases: @@TODO@@
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
              //
              // TODO: Test.
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1.2.1.2: hasXActiveUI: FALSE");
              //
              // TODO: Test.
              forceReloadItem = true;
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
              //
              // @@TODO@@: Test.
              forceReloadItem = false;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.1.2.2.2: hasXActiveUI: FALSE");
              //
              // @@TODO@@ Test.
              forceReloadItem = false;
            }
          }
        }
      }
      // ITEM != ITEM_DETAIL
      else {
        _printDebugState(
            "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2: ITEM != ITEM_DETAIL");
        //
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
              // @@TODO@@ Test.
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.1.1.2: hasXActiveUI: FALSE");
              // @@TODO@@ Test.
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
              // @@TODO@@ Test.
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.1.2.2: hasXActiveUI: FALSE");
              // @@TODO@@ Test.
              forceReloadItem = true;
            }
          }
        }
        // !isCandidateCurrentItemInNewQueriedList
        else {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.2: isCandidateCurrentItemInNewQueriedList: TRUE");
          //
          if (currentItemChanged) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.2.1: currentItemChanged: TRUE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.2.1.1: hasXActiveUI: TRUE");
              // @@TODO@@ Test.
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.2.1.2: hasXActiveUI: FALSE");
              // @@TODO@@ Test.
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
              // @@TODO@@ Test.
              forceReloadItem = false;
            } else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 1.2.2.2.2: hasXActiveUI: FALSE");
              // @@TODO@@ Test.
              forceReloadItem = false;
            }
          }
        }
      }
    case CurrentItemSelectionType.selectAnItemAsCurrent:
      _printDebugState(
          "@~~~> ${getClassName(block)} ~~~~~> ITM 2: currentItemSelectionType: ${currentItemSelectionType.name}");
      //
      if (block.getItemType() == block.getItemDetailType()) {
        _printDebugState(
            "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1: ITEM == ITEM_DETAIL");
        //
        if (isCandidateCurrentItemInNewQueriedList) {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.1: isCandidateCurrentItemInNewQueriedList: TRUE");
          //
          if (hasXActiveUI) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.1.1: hasXActiveUI: TRUE");
            // @@TODO@@ Test.
            forceReloadItem = true;
          }
          // !hasXActiveUI
          else {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.1.2: hasXActiveUI: FALSE");
            // @@TODO@@ Test.
            forceReloadItem = true;
          }
        }
        // !isCandidateCurrentItemInNewQueriedList
        else {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.2: isCandidateCurrentItemInNewQueriedList: TRUE");
          //
          if (currentItemChanged) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.2.1: currentItemChanged: TRUE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.2.1.1: hasXActiveUI: TRUE");
              // @@TODO@@ Test.
              forceReloadItem = true;
            }
            // !hasXActiveUI
            else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.2.1.2: hasXActiveUI: FALSE");
              // @@TODO@@ Test.
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
              // @@TODO@@ Test.
              // Ready selected as current (No need to refresh):
              forceReloadItem = false;
            } else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.1.2.2.2: hasXActiveUI: FALSE");
              // @@TODO@@ Test.
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
        //
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
              // @@TODO@@ Test.
              forceReloadItem = true;
            } else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.1.1.2: hasXActiveUI: FALSE");
              // @@TODO@@ Test.
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
              // @@TODO@@ Test.
              forceReloadItem = true;
            } else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.1.2.2: hasXActiveUI: FALSE");
              // @@TODO@@ Test.
              forceReloadItem = true;
            }
          }
        }
        // !isCandidateCurrentItemInNewQueriedList
        else {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.2: isCandidateCurrentItemInNewQueriedList: TRUE");
          //
          if (currentItemChanged) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.2.1: currentItemChanged: TRUE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.2.1.1: hasXActiveUI: TRUE");
              // @@TODO@@ Test.
              forceReloadItem = true;
            } else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.2.1.2: hasXActiveUI: FALSE");
              // @@TODO@@ Test.
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
              // @@TODO@@ Test.
              forceReloadItem = false;
            } else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 2.2.2.2.2: hasXActiveUI: FALSE");
              // @@TODO@@ Test.
              forceReloadItem = false;
            }
          }
        }
      }
    case CurrentItemSelectionType.selectAnItemAsCurrentAndLoadForm:
      _printDebugState(
          "@~~~> ${getClassName(block)} ~~~~~> ITM 3: currentItemSelectionType: ${currentItemSelectionType.name}");
      //
      //
      if (block.getItemType() == block.getItemDetailType()) {
        _printDebugState(
            "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1: ITEM == ITEM_DETAIL");
        //
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
              // @@TODO@@ Test.
              forceReloadItem = true;
            } else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.1.1.2: hasXActiveUI: FALSE");
              // @@TODO@@ Test.
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
              // @@TODO@@ Test.
              forceReloadItem = true;
            } else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.1.2.2: hasXActiveUI: FALSE");
              // @@TODO@@ Test.
              forceReloadItem = true;
            }
          }
        }
        // !isCandidateCurrentItemInNewQueriedList
        else {
          _printDebugState(
              "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.2: isCandidateCurrentItemInNewQueriedList: TRUE");
          //
          if (currentItemChanged) {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.2.1: currentItemChanged: TRUE");
            //
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.2.1.1: hasXActiveUI: TRUE");
              // @@TODO@@ Test.
              forceReloadItem = true;
            } else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.2.1.2: hasXActiveUI: FALSE");
              // @@TODO@@ Test.
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
              // @@TODO@@ Test.
              forceReloadItem = true;
            } else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.1.2.2.2: hasXActiveUI: FALSE");
              // @@TODO@@ Test.
              forceReloadItem = true;
            }
          }
        }
      }
      // ITEM != ITEM_DETAIL
      else {
        _printDebugState(
            "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2: ITEM != ITEM_DETAIL");
        //
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
              // @@TODO@@ Test.
              forceReloadItem = true;
            } else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.1.1.2: hasXActiveUI: FALSE");
              // @@TODO@@ Test.
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
              // @@TODO@@ Test.
              forceReloadItem = true;
            } else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.1.2.2: hasXActiveUI: FALSE");
              // @@TODO@@ Test.
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
              // @@TODO@@ Test.
              forceReloadItem = true;
            } else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.2.1.2: hasXActiveUI: FALSE");
              // @@TODO@@ Test.
              forceReloadItem = true;
            }
          }
          // !currentItemChanged
          else {
            _printDebugState(
                "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.2.2: currentItemChanged: FALSE");
            // [40b]
            forceReloadItem = false;
            if (hasXActiveUI) {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.2.2.1: hasXActiveUI: TRUE");
              // Ready selected as current (No need to refresh):
              // @@TODO@@ Test.
              forceReloadItem = false;
            } else {
              _printDebugState(
                  "@~~~> ${getClassName(block)} ~~~~~> ITM 3.2.2.2.2: hasXActiveUI: FALSE");
              // Ready selected as current (No need to refresh):
              // @@TODO@@ Test.
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
  return _ForceReloadItemState(forceReloadItem: forceReloadItem);
}
