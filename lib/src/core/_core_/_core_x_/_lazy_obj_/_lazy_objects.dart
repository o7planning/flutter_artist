part of '../../core.dart';

class _LazyObjects {
  final Map<String, _LazyFilterModel> __lazyFilterModelsMap = {};
  final List<_LazyBlock> lazyBlocks = [];
  final List<_LazyScalar> lazyScalars = [];
  final List<_LazyFormModel> lazyFormModels = [];

  List<_LazyFilterModel> get lazyFilterModels {
    return __lazyFilterModelsMap.values.toList();
  }

  bool get isEmpty {
    return lazyBlocks.isEmpty &&
        lazyScalars.isEmpty &&
        lazyFormModels.isEmpty &&
        lazyFilterModels.isEmpty;
  }

  int get count {
    return lazyBlocks.length +
        lazyScalars.length +
        lazyFormModels.length +
        lazyFilterModels.length;
  }

  void addLazyFilterModel({required FilterModel filterModel}) {
    if (!__lazyFilterModelsMap.containsKey(filterModel.name)) {
      __lazyFilterModelsMap[filterModel.name] = _LazyFilterModel(
        filterModel: filterModel,
      );
    }
  }

  void addLazyScalar({required Scalar scalar}) {
    lazyScalars.add(_LazyScalar(scalar: scalar));
  }

  void addLazyBlock({required Block block, required QryHint queryHint}) {
    lazyBlocks.add(_LazyBlock(block: block, queryHint: queryHint));
  }

  void addLazyFormModel({required FormModel formModel}) {
    lazyFormModels.add(_LazyFormModel(formModel: formModel));
  }

  void printInfo() {
    print("@@-LazyFilterModels: $lazyFilterModels");
    print("@@-LazyBlocks: $lazyBlocks");
    print("@@-lazyScalars: $lazyScalars");
    print("@@-LazyFormModels: $lazyFormModels");
  }
}
