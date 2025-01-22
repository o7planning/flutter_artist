part of '../flutter_artist.dart';

typedef ControlPressedAsyncFunction = Future<bool> Function();

abstract class BlockControl extends _StatefulWidget {
  final Block block;
  final StackTrace? currentStackTrace;
  final Widget Function(VoidCallback? onPressed) build;
  final VoidCallback? navigate;
  final ControlButtonType controlButtonType;

  const BlockControl({
    super.key,
    required this.currentStackTrace,
    required super.ownerClassInstance,
    super.description,
    required this.block,
    required this.build,
    required this.controlButtonType,
    required this.navigate,
  });

  @override
  State<StatefulWidget> createState() {
    return _ControlButtonState();
  }
}

class _ControlButtonState extends _WidgetState<BlockControl> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  WidgetStateType get type => WidgetStateType.customControlBar;

  @override
  Widget buildContent(BuildContext context) {
    ControlPressedAsyncFunction? onPressedAsync = _getOnPressedFunction();
    //
    return widget.build(
      onPressedAsync == null
          ? null
          : () {
              () async {
                bool success = await onPressedAsync!();
                if (success && widget.navigate != null) {
                  widget.navigate!();
                }
              }();
            },
    );
  }

  ControlPressedAsyncFunction? _getOnPressedFunction() {
    switch (widget.controlButtonType) {
      case ControlButtonType.create:
        bool canCreate = widget.block.canCreateItem();
        return canCreate ? __prepareToCreate : null;
      case ControlButtonType.query:
        bool canQuery = widget.block.canQuery();
        return canQuery ? __queryBlock : null;
      case ControlButtonType.save:
        bool canSave = widget.block.canSave();
        return canSave ? __saveForm : null;
    }
  }

  Future<bool> __back() async {
    FlutterArtist.adapter.navigationBack();
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
    return await widget.block.blockForm!.saveForm();
  }

  Future<bool> __doDelete() async {
    return await widget.block.deleteCurrentItem();
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
    widget.block.blockForm?.resetForm();
    return true;
  }

  Future<bool> __refreshForm() async {
    return await widget.block.refreshCurrentItem();
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
  void addWidgetStateListener({required bool isShowing}) {
    widget.block._addControlButtonWidgetStateListener(
      formWidgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeWidgetStateListener() {
    widget.block._removeControlButtonWidgetStateListener(
      formWidgetState: this,
    );
  }
}
