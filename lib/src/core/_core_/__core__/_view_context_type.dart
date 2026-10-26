part of '../core.dart';

enum BlockViewContext {
  items,
  itemDetail,
  form;

  bool get provideItemsContext {
    return switch (this) {
      BlockViewContext.items => true,
      BlockViewContext.itemDetail => true,
      BlockViewContext.form => true,
    };
  }

  bool get provideItemDetailContext {
    return switch (this) {
      BlockViewContext.items => false,
      BlockViewContext.itemDetail => true,
      BlockViewContext.form => true,
    };
  }

  bool get provideFormContext {
    return switch (this) {
      BlockViewContext.items => false,
      BlockViewContext.itemDetail => false,
      BlockViewContext.form => true,
    };
  }
}

enum ScalarViewContext {
  value;

  bool get provideValueContext {
    return switch (this) {
      ScalarViewContext.value => true,
    };
  }
}

enum TaskViewContext {
  initData,
  form;

  bool get provideInitDataContext {
    return switch (this) {
      TaskViewContext.initData => true,
      TaskViewContext.form => true,
    };
  }

  bool get provideFormContext {
    return switch (this) {
      TaskViewContext.initData => false,
      TaskViewContext.form => true,
    };
  }
}

enum StageViewContext {
  initData,
  form;

  bool get provideInitDataContext {
    return switch (this) {
      StageViewContext.initData => true,
      StageViewContext.form => true,
    };
  }

  bool get provideFormContext {
    return switch (this) {
      StageViewContext.initData => false,
      StageViewContext.form => true,
    };
  }
}

enum ProzessViewContext {
  initData;

  bool get provideInitDataContext {
    return switch (this) {
      ProzessViewContext.initData => true,
    };
  }
}
