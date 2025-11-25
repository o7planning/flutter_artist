part of '../core.dart';

class ForceReloadDebug {
  String currentShelfCodes;
  final SplayTreeSet<String> shelfCodeSet = SplayTreeSet<String>();

  ForceReloadDebug(this.currentShelfCodes);

  void addShelfCode(String shelfCode) {
    shelfCodeSet.add(shelfCode);
  }

  String toShelfCodes() {
    return shelfCodeSet.join(", ");
  }
}

final Map<String, ForceReloadDebug> forceReloadMap = {};

void initDebugForceReloadMap() {
  List<String> testCodes = [
    "ITM 1.2.1.1.2", "FRM 1.2.1.1.2", "ITM 1.2.2.1.1", //
    "FRM 1.2.2.1.1", "ITM 2.2.1.1.2", "FRM 2.2.1.1.2", //
    "ITM 1.2.2.2.1", "FRM 1.2.2.2.1.2.1", "ITM 3.2.1.1.2", //
    "FRM 3.2.1.1.2", "ITM 1.2.1.1.1", "FRM 1.2.1.1.1", //
    "ITM 2.2.1.1.1", "FRM 2.2.1.1.1", "ITM 3.2.1.1.1", //
    "FRM 3.2.1.1.1", "ITM 1.2.1.2.1", "FRM 1.2.1.2.1", //
    "FRM 1.2.2.2.1.1", "ITM 2.2.1.2.1", "FRM 2.2.1.2.1", //
    "ITM 3.2.1.2.1", "FRM 3.2.1.2.1", "ITM 2.2.2.1.1", //
    "FRM 2.2.2.1.1", "ITM 3.2.2.1.1", "FRM 3.2.2.1.1", //
    "FRM 1.2.2.2.1.2.2", "ITM 2.2.2.2.1", "FRM 2.2.2.2.1.1.2", //
    "ITM 3.2.2.2.1", "FRM 3.2.2.2.1.2.2", "ITM 2.2.2.1.2", //
    "FRM 2.2.2.1.2", "FRM 1.2.2.1.2", "ITM 2.2.2.2.2", //
    "FRM 2.2.2.2.2", "ITM 3.2.2.1.2", "FRM 3.2.2.1.2", //
    "ITM 3.2.2.2.2", "FRM 3.2.2.2.2.2", "ITM 1.2.2.2.2", //
    "FRM 1.2.2.2.2", "ITM 1.1.1.1.1", "FRM 1.1.1.1.1", //
    "FRM 1.1.2.1.1", "ITM 1.1.1.2.1", "FRM 1.1.1.2.1", //
    "ITM 1.1.2.2.1", "FRM 1.1.2.2.1.2.2", "ITM 1.1.1.1.2", //
    "FRM 1.1.1.1.2", "ITM 3.1.1.1.2", "FRM 3.1.1.1.2", //
    "ITM 3.1.1.2.2", "FRM 3.1.1.2.2", "ITM 3.1.1.2.1", //
    "FRM 3.1.1.2.1", "ITM 2.1.1.1.2", "FRM 2.1.1.1.2", //
    "ITM 2.1.1.2.2", "FRM 2.1.1.2.2", "FRM 1.1.2.2.1.2.1", //
    "ITM 2.1.1.2.1", "FRM 2.1.1.2.1", "ITM 1.1.1.2.2", //
    "FRM 1.1.1.2.2", //
  ];
  //
  for (String testCode in testCodes) {
    forceReloadMap[testCode] = ForceReloadDebug("");
  }
}

void printDebugForceReloadMap() {
  print(" **************************************************************** ");
  print(" **************************************************************** ");
  // key: 20a, 43a,..
  int i = 1;
  for (String key in forceReloadMap.keys) {
    ForceReloadDebug debug = forceReloadMap[key]!;
    String newTestCodes = debug.toShelfCodes();
    bool changed = debug.currentShelfCodes != newTestCodes;
    if (!changed && key.startsWith("ITM")) {
      print("${i.toString().padLeft(2, '0')} KEY: $key - $newTestCodes");
      i++;
    }
  }
  //
  print("\n");
  int j = 1;
  for (String key in forceReloadMap.keys) {
    ForceReloadDebug debug = forceReloadMap[key]!;
    String newTestCodes = debug.toShelfCodes();
    bool changed = debug.currentShelfCodes != newTestCodes;
    if (changed && key.startsWith("ITM")) {
      print(
          "${j.toString().padLeft(2, '0')} KEY: $key - $newTestCodes ${changed
              ? '***'
              : ''}");
      j++;
    }
  }
  // key: 20a, 43a,..
  i = 1;
  for (String key in forceReloadMap.keys) {
    ForceReloadDebug debug = forceReloadMap[key]!;
    String newTestCodes = debug.toShelfCodes();
    bool changed = debug.currentShelfCodes != newTestCodes;
    if (!changed && key.startsWith("FRM")) {
      print("${i.toString().padLeft(2, '0')} KEY: $key - $newTestCodes");
      i++;
    }
  }
  //
  print("\n");
  j = 1;
  for (String key in forceReloadMap.keys) {
    ForceReloadDebug debug = forceReloadMap[key]!;
    String newTestCodes = debug.toShelfCodes();
    bool changed = debug.currentShelfCodes != newTestCodes;
    if (changed && key.startsWith("FRM")) {
      print(
          "${j.toString().padLeft(2, '0')} KEY: $key - $newTestCodes ${changed
              ? '***'
              : ''}");
      j++;
    }
  }
  // ALL KEYS:
  print("\n");
  int k = 1;
  List<String> allKeys = [...forceReloadMap.keys];
  final int subLength = 3;
  while (true) {
    if (allKeys.isEmpty) {
      break;
    }
    List<String> subList = [];
    int idx = 0;
    while (true) {
      idx++;
      if (allKeys.isEmpty || idx > subLength) {
        break;
      }
      String key = allKeys.removeAt(0);
      subList.add(key);
    }
    String s = subList.map((key) => '"$key"').join(", ");
    print("$s, //");
  }
  print(" **************************************************************** ");
  print(" **************************************************************** ");
}

void _addDebugForceReload({
  required String debugCode,
  required String currentShelfCodes, // "20a, 30b"
  required Shelf shelf,
}) {
  if (currentShelfCodes.isEmpty) {
    __throwForceReloadError(debugCode);
  }
  String clsName = getClassName(shelf);
  if (!clsName.endsWith("Shelf")) {
    return;
  }
  clsName = clsName.substring(0, clsName.length - "Shelf".length);
  if (clsName.length < 3) {
    return;
  }
  final String testCode = clsName.substring(clsName.length - 3);
  String noStr = testCode.substring(0, 2);
  int? no = int.tryParse(noStr);
  if (no != null) {
    ForceReloadDebug? debug = forceReloadMap[debugCode];
    if (debug == null) {
      debug = ForceReloadDebug("");
      forceReloadMap[debugCode] = debug;
    }
    // currentShelfCodes = "20a, 30b".
    debug.currentShelfCodes = currentShelfCodes;
    debug.addShelfCode(testCode);
  }
}

class _ForceReloadFormState {
  final bool forceReloadForm;
  final bool forceReloadItem;

  const _ForceReloadFormState({
    required this.forceReloadItem,
    required this.forceReloadForm,
  });
}

class _ForceReloadItemState {
  final bool forceReloadItem;

  const _ForceReloadItemState({required this.forceReloadItem});
}
