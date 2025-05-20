part of '../../flutter_artist.dart';

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
    String newTestCodes = debug.toShelfCodes();
    bool changed = debug.currentShelfCodes != newTestCodes;
    if (changed && newTestCodes.isNotEmpty) {
      print(
          "${j.toString().padLeft(2, '0')} KEY: $key - $newTestCodes ${changed ? '***' : ''}");
      j++;
    }
  }
  // ALL KEYS:
  print("\n");
  int k = 1;
  Iterable<String> allKeys = forceReloadMap.keys;
  String s = allKeys.map((key) => '"$key"').join(", ");
  print(s);
  print(" **************************************************************** ");
  print(" **************************************************************** ");
}

void _addDebugForceReload({
  required String debugCode,
  required String currentShelfCodes, // "20a, 30b"
  required Shelf shelf,
}) {
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
      return;
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
