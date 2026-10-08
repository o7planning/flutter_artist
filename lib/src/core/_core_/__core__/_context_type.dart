part of '../core.dart';

enum BlockContextType {
  items,
  itemDetail,
  form;

  bool get provideItemsContext {
    return switch (this) {
      BlockContextType.items => true,
      BlockContextType.itemDetail => true,
      BlockContextType.form => true,
    };
  }

  bool get provideItemDetailContext {
    return switch (this) {
      BlockContextType.items => false,
      BlockContextType.itemDetail => true,
      BlockContextType.form => true,
    };
  }

  bool get provideFormContext {
    return switch (this) {
      BlockContextType.items => false,
      BlockContextType.itemDetail => false,
      BlockContextType.form => true,
    };
  }
}

enum ScalarContextType {
  value;

  bool get provideValueContext {
    return switch (this) {
      ScalarContextType.value => true,
    };
  }
}

enum TaskContextType {
  initData,
  form;

  bool get provideInitDataContext {
    return switch (this) {
      TaskContextType.initData => true,
      TaskContextType.form => true,
    };
  }

  bool get provideFormContext {
    return switch (this) {
      TaskContextType.initData => false,
      TaskContextType.form => true,
    };
  }
}

enum StageContextType {
  initData,
  form;

  bool get provideInitDataContext {
    return switch (this) {
      StageContextType.initData => true,
      StageContextType.form => true,
    };
  }

  bool get provideFormContext {
    return switch (this) {
      StageContextType.initData => false,
      StageContextType.form => true,
    };
  }
}
