part of '../../_fa_core.dart';

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
        Actionable createActionable = widget.block.canCreateItemWithForm();
        return createActionable.yes ? __prepareFormToCreateItem : null;
      case BlockControlActionType.query:
        Actionable queryActionable = widget.block.canQuery();
        return queryActionable.yes ? __queryBlock : null;
      case BlockControlActionType.saveForm:
        Actionable<BlockFormSavePrecheck> saveActionable =
            widget.block.canSaveForm();
        return saveActionable.yes ? __saveForm : null;
      case BlockControlActionType.refreshCurrentItem:
        Actionable refreshActionable = widget.block.canRefreshCurrentItem();
        return refreshActionable.yes ? __refreshCurrentItem : null;
      case BlockControlActionType.resetForm:
        Actionable resetActionable = widget.block.canResetForm();
        return resetActionable.yes ? __resetForm : null;
      case BlockControlActionType.deleteCurrentItem:
        Actionable deleteActionable = widget.block.canDeleteCurrentItem();
        return deleteActionable.yes ? __deleteCurrentItem : null;
      case BlockControlActionType.showFormInfo:
        Actionable formInfoActionable = widget.block.canShowFormInfo();
        return formInfoActionable.yes ? __showFormInfo : null;
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
    FormSaveResult result = await widget.block.formModel!.saveForm();
    return result.success;
  }

  Future<bool> __deleteCurrentItem() async {
    return await widget.block.deleteCurrentItem() != null;
  }

  Future<bool> __prepareFormToCreateItem() async {
    if (widget.currentStackTrace != null) {
      FlutterArtist.codeFlowLogger.addMethodCall(
        ownerClassInstance: widget.ownerClassInstance,
        currentStackTrace: widget.currentStackTrace!,
        parameters: {},
      );
    }
    //
    PrepareItemCreationResult result =
        await widget.block.prepareFormToCreateItem(
      navigate: null,
    );
    return result.success;
  }

  Future<bool> __resetForm() async {
    widget.block.formModel?.resetForm();
    return true;
  }

  Future<bool> __refreshCurrentItem() async {
    return await widget.block.refreshCurrentItem() != null;
  }

  Future<bool> __showFormInfo() async {
    FormDataInfoDialog.showFormInfoDialog(
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
    BlockQueryResult result = await widget.block.query();
    return result.success;
  }

  @override
  void addWidgetState({required bool isShowing}) {
    widget.block._addControlWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeWidgetState() {
    widget.block._removeControlWidgetState(
      widgetState: this,
    );
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.block.shelf);
  }

  @override
  void executeAfterBuild() {
    // Do nothing.
  }

  @override
  void setBuildingState({required bool isBuilding}) {
    //
  }
}
