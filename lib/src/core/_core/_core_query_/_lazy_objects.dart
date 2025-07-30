part of '../code.dart';

class _LazyBlock {
  final Block block;
  final bool forceQuery;

  _LazyBlock({required this.block, required this.forceQuery});

  @override
  String toString() {
    return "(${block.name},forceQuery: $forceQuery)";
  }
}

class _LazyScalar {
  final Scalar scalar;

  _LazyScalar({required this.scalar});

  @override
  String toString() {
    return "(${scalar.name})";
  }
}

class _LazyFormModel {
  final FormModel formModel;

  _LazyFormModel({required this.formModel});

  @override
  String toString() {
    return "(${formModel.block.name})";
  }
}

class _LazyObjects {
  final List<_LazyBlock> lazyBlocks = [];
  final List<_LazyScalar> lazyScalars = [];
  final List<_LazyFormModel> lazyFormModels = [];

  bool get isEmpty {
    return lazyBlocks.isEmpty && lazyScalars.isEmpty && lazyFormModels.isEmpty;
  }

  int get count {
    return lazyBlocks.length + lazyScalars.length + lazyFormModels.length;
  }

  void addLazyScalar({required Scalar scalar}) {
    lazyScalars.add(_LazyScalar(scalar: scalar));
  }

  void addLazyBlock({required Block block, required bool forceQuery}) {
    lazyBlocks.add(_LazyBlock(block: block, forceQuery: forceQuery));
  }

  void addLazyFormModel({required FormModel formModel}) {
    lazyFormModels.add(_LazyFormModel(formModel: formModel));
  }

  void printInfo() {
    print("@@-LazyBlocks: $lazyBlocks");
    print("@@-lazyScalars: $lazyScalars");
    print("@@-LazyFormModels: $lazyFormModels");
  }
}
