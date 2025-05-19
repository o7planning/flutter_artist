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

void printDebugForceReloadMap() {
  print(" **************************************************************** ");
  print(" **************************************************************** ");
  // key: 20a, 43a,..
  for (String key in forceReloadMap.keys) {
    ForceReloadDebug debug = forceReloadMap[key]!;
    print("KEY: $key - ${debug.toTestCodes}");
  }
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
  clsName = clsName.substring(clsName.length - "Block".length);
  if (clsName.length < 3) {
    return;
  }
  final String testCode = clsName.substring(clsName.length - 3);
  String noStr = testCode.substring(0, 2);
  int? no = int.tryParse(noStr);
  if (no != null) {
    ForceReloadDebug? debug = forceReloadMap[debugCode];
    if (debug == null) {
      debug = ForceReloadDebug(testCodes);
      forceReloadMap[debugCode] = debug;
    }
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
