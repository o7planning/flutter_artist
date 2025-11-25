part of '../core.dart';

abstract class StorageStructure {
  void registerAutoStockers();

  void registerShelves();

  List<PolymorphismFamily> registerPolymorphisms();
}
