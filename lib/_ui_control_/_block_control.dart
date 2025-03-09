part of '../flutter_artist.dart';

typedef ControlPressedAsyncFunction = Future<bool> Function();

abstract class BlockControl extends _RefreshableWidget {
  final Block block;
  final StackTrace? currentStackTrace;
  final Widget Function(VoidCallback? onPressed) build;
  final VoidCallback? navigate;
  final BlockControlActionType actionType;

  const BlockControl({
    super.key,
    required this.currentStackTrace,
    required super.ownerClassInstance,
    super.description,
    required this.block,
    required this.build,
    required this.actionType,
    required this.navigate,
  });

  @override
  State<StatefulWidget> createState() {
    return _BlockControlButtonState();
  }
}

class _BlockControlButtonState extends _RefreshableWidgetState<BlockControl> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.blockControlButton;

  @override
  Widget buildContent(BuildContext context) {
    ControlPressedAsyncFunction? onPressedAsync = _getOnPressedFunction();
    //
    return widget.build(
      onPressedAsync == null
          ? null
          : () {
              () async {
                bool success = await onPressedAsync();
                if (success && widget.navigate != null) {
                  widget.navigate!();
                }
              }();
            },
    );
  }

  ControlPressedAsyncFunction? _getOnPressedFunction() {
    switch (widget.actionType) {
      case BlockControlActionType.createItem:
        bool canCreate = widget.block.canCreateItem();
        return canCreate ? __prepareToCreate : null;
      case BlockControlActionType.query:
        bool canQuery = widget.block.canQuery();
        return canQuery ? __queryBlock : null;
      case BlockControlActionType.saveForm:
        bool canSaveForm = widget.block.canSaveForm();
        return canSaveForm ? __saveForm : null;
      case BlockControlActionType.refreshCurrentItem:
        bool canRefreshCurrentItem = widget.block.canRefreshCurrentItem();
        return canRefreshCurrentItem ? __refreshCurrentItem : null;
      case BlockControlActionType.resetForm:
        bool canResetForm = widget.block.canResetForm();
        return canResetForm ? __resetForm : null;
      case BlockControlActionType.deleteCurrentItem:
        bool canDeleteCurrentItem = widget.block.canDeleteCurrentItem();
        return canDeleteCurrentItem ? __deleteCurrentItem : null;
      case BlockControlActionType.showFormInfo:
        bool canShowFormInfo = widget.block.canShowFormInfo();
        return canShowFormInfo ? __showFormInfo : null;
    }
  }

  Future<bool> __back(BuildContext context) async {
    Navigator.of(context).maybePop();
    return true;
  }

  Future<bool> __saveForm() async {
    if (widget.currentStackTrace != null) {
      FlutterArtist.codeFlowLogger.addMethodCall(
        ownerClassInstance: widget.ownerClassInstance,
        currentStackTrace: widget.currentStackTrace!,
        parameters: {},
      );
    }
    //
    return await widget.block.formModel!.saveForm();
  }

  Future<bool> __deleteCurrentItem() async {
    return await widget.block.deleteCurrentItem() != null;
  }

  Future<bool> __prepareToCreate() async {
    if (widget.currentStackTrace != null) {
      FlutterArtist.codeFlowLogger.addMethodCall(
        ownerClassInstance: widget.ownerClassInstance,
        currentStackTrace: widget.currentStackTrace!,
        parameters: {},
      );
    }
    //
    return await widget.block.prepareToCreate(navigate: null);
  }

  Future<bool> __resetForm() async {
    widget.block.formModel?.resetForm();
    return true;
  }

  Future<bool> __refreshCurrentItem() async {
    return await widget.block.refreshCurrentItem() != null;
  }

  Future<bool> __showFormInfo() async {
    _showFormInfoDialog(
      context: context,
      locationInfo: getClassName(widget.ownerClassInstance),
      formModel: widget.block.formModel!,
    );
    return true;
  }

  Future<bool> __queryBlock() async {
    if (widget.currentStackTrace != null) {
      FlutterArtist.codeFlowLogger.addMethodCall(
        ownerClassInstance: widget.ownerClassInstance,
        currentStackTrace: widget.currentStackTrace!,
        parameters: {},
      );
    }
    //
    return await widget.block.query();
  }

  @override
  void addFilterFragmentWidgetState({required bool isShowing}) {
    widget.block._addControlWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeFilterFragmentWidgetState() {
    widget.block._removeControlWidgetState(
      widgetState: this,
    );
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.block.shelf);
  }
}
