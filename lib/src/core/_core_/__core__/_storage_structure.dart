part of '../core.dart';

abstract class StorageStructure {
  void registerShelves();

  void registerAutoStockers();

  List<PolymorphismFamily> registerPolymorphismFamilies();
}
