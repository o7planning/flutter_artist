part of '../core.dart';

abstract class StorageStructure {
  void registerActivities();

  void registerShelves();

  List<PolymorphismFamily> registerPolymorphismFamilies();
}

class _DebugRegister {
  final List<String> __debugRegisterShelves = [];
  final List<String> __debugRegisterActivities = [];
  final List<String> __debugRegisterPolymorphisms = [];

  List<String> get debugRegisterShelves => __debugRegisterShelves;

  List<String> get debugRegisterActivities => __debugRegisterActivities;

  List<String> get debugRegisterPolymorphisms => __debugRegisterPolymorphisms;

  void _addDebugRegisterShelf(String info) {
    __debugRegisterShelves.add(info);
  }

  void _addDebugRegisterActivity(String info) {
    __debugRegisterActivities.add(info);
  }

  void _addDebugRegisterPolymorphism(String info) {
    __debugRegisterPolymorphisms.add(info);
  }

  void printInfo() {
    print("1 - ${__debugRegisterShelves.firstOrNull}");
    print("2 - ${__debugRegisterActivities.firstOrNull}");
    print("4 - ${__debugRegisterPolymorphisms.firstOrNull}");
  }
}
