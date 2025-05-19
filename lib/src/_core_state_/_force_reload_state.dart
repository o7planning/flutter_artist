part of '../../flutter_artist.dart';

class ForceReloadDebug {
  String testCodes;
  final SplayTreeSet<String> testCodeSet = SplayTreeSet<String>();

  ForceReloadDebug(this.testCodes);

  void addTestCode(String testCode) {
    testCodeSet.add(testCode);
  }

  String toTestCodes() {
    return testCodeSet.join(", ");
  }
}

final Map<String, ForceReloadDebug> forceReloadMap = {};

void initDebugForceReloadMap() {
  forceReloadMap["ITM 1.1.1.1.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 1.1.1.1.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 1.1.1.2.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 1.1.1.2.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 1.1.2.1.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 1.1.2.1.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 1.1.2.2.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 1.1.2.2.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 1.2.1.1.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 1.2.1.1.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 1.2.1.2.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 1.2.1.2.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 1.2.2.1.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 1.2.2.1.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 1.2.2.2.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 1.2.2.2.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 2.1.1.1.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 2.1.1.1.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 2.1.1.2.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 2.1.1.2.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 2.1.2.1.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 2.1.2.1.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 2.1.2.2.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 2.1.2.2.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 2.2.1.1.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 2.2.1.1.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 2.2.1.2.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 2.2.1.2.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 2.2.2.1.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 2.2.2.1.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 2.2.2.2.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 2.2.2.2.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 3.1.1.1.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 3.1.1.1.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 3.1.1.2.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 3.1.1.2.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 3.1.2.1.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 3.1.2.1.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 3.1.2.2.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 3.1.2.2.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 3.2.1.1.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 3.2.1.1.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 3.2.1.2.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 3.2.1.2.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 3.2.2.1.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 3.2.2.1.2"] = ForceReloadDebug("");
  forceReloadMap["ITM 3.2.2.2.1"] = ForceReloadDebug("");
  forceReloadMap["ITM 3.2.2.2.2"] = ForceReloadDebug("");
}

void printDebugForceReloadMap() {
  print(" **************************************************************** ");
  print(" **************************************************************** ");
  // key: 20a, 43a,..
  int i = 1;
  for (String key in forceReloadMap.keys) {
    ForceReloadDebug debug = forceReloadMap[key]!;
    String newTestCodes = debug.toTestCodes();
    bool changed = debug.testCodes != newTestCodes;
    if (!changed && newTestCodes.isNotEmpty) {
      print("${i.toString().padLeft(2, '0')} KEY: $key - $newTestCodes");
      i++;
    }
  }
  //
  print("\n");
  int j = 1;
  for (String key in forceReloadMap.keys) {
    ForceReloadDebug debug = forceReloadMap[key]!;
    String newTestCodes = debug.toTestCodes();
    bool changed = debug.testCodes != newTestCodes;
    if (changed && newTestCodes.isNotEmpty) {
      print(
          "${j.toString().padLeft(2, '0')} KEY: $key - $newTestCodes ${changed ? '***' : ''}");
      j++;
    }
  }
  //
  print("\n");
  int k = 1;
  for (String key in forceReloadMap.keys) {
    ForceReloadDebug debug = forceReloadMap[key]!;
    String newTestCodes = debug.toTestCodes();
    if (newTestCodes.isEmpty) {
      print("${k.toString().padLeft(2, '0')} EMPTY: $key");
      k++;
    }
  }
  print(" **************************************************************** ");
  print(" **************************************************************** ");
}

void _addDebugForceReload({
  required String debugCode,
  required String testCodes, // "20a, 30b"
  required Block block,
}) {
  String clsName = getClassName(block);
  if (!clsName.endsWith("Block")) {
    return;
  }
  clsName = clsName.substring(0, clsName.length - "Block".length);
  if (clsName.length < 3) {
    return;
  }
  final String testCode = clsName.substring(clsName.length - 3);

  String noStr = testCode.substring(0, 2);
  int? no = int.tryParse(noStr);
  if (no != null) {
    ForceReloadDebug? debug = forceReloadMap[debugCode];
    if (debug == null) {
      return;
    }
    // testCodes = "20a, 30b".
    debug.testCodes = testCodes;
    debug.addTestCode(testCode);
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
