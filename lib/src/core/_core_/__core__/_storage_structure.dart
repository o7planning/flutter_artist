part of '../core.dart';

abstract class StorageStructure {
  void registerActivities();

  void registerShelves();

  List<ProjectionFamily> defineProjectionFamilies();
}

class _DebugRegister {
  final List<String> __debugRegisterShelves = [];
  final List<String> __debugRegisterActivities = [];
  final List<String> __debugRegisterProjections = [];

  List<String> get debugRegisterShelves => __debugRegisterShelves;

  List<String> get debugRegisterActivities => __debugRegisterActivities;

  List<String> get debugRegisterProjections => __debugRegisterProjections;

  void _addDebugRegisterShelf(String info) {
    __debugRegisterShelves.add(info);
  }

  void _addDebugRegisterActivity(String info) {
    __debugRegisterActivities.add(info);
  }

  void _addDebugRegisterProjection(String info) {
    __debugRegisterProjections.add(info);
  }

  void printInfo() {
    print("1 - ${__debugRegisterShelves.firstOrNull}");
    print("2 - ${__debugRegisterActivities.firstOrNull}");
    print("4 - ${__debugRegisterProjections.firstOrNull}");
  }
}
