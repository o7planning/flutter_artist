part of '../../core.dart';

abstract class BaseFormViewBuilder<M extends BaseFormModel>
    extends _ContextProviderView {
  final M formModel;
  final Widget Function() build;

  FormViewConfig get config;

  const BaseFormViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.formModel,
    required this.build,
  });
}

abstract class _BaseFormViewBuilderState<W extends BaseFormViewBuilder<M>,
    M extends BaseFormModel> extends _ContextProviderViewState<W> {
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.formModel);
  }

  @override
  void setBuildingState({required bool isBuilding}) {
    widget.formModel.ui._setFormViewBuildingState(
      widgetState: this,
      isBuilding: isBuilding,
    );
  }

  @override
  void addWidgetState({required bool isVisible}) {
    widget.formModel.ui._addFormWidgetState(
      widgetState: this,
      isVisible: isVisible,
    );
  }

  @override
  void removeWidgetState() {
    widget.formModel.ui._removeFormWidgetState(
      widgetState: this,
    );
  }

  @override
  void executeAfterBuild() {
    widget.formModel._afterBuildFormView();
  }

  Future<void> _onPopInvokedWithResult(bool didPop, dynamic result) async {
    if (didPop || !widget.formModel.isDirty()) {
      return;
    }
    _leavingDirtyForms[widget.formModel.pathInfo] = widget.formModel;

    dialogs.YesNoCancel selection = dialogs.YesNoCancel.cancel;
    try {
      selection = await dialogs.showYesNoCancelDialog(
        context: context,
        message:
            "Do you want to save changes to [${getClassName(widget.formModel)}] before closing?",
        details: "",
        defaultOption: dialogs.YesNoCancel.yes,
      );
    } finally {
      _leavingDirtyForms.remove(widget.formModel.pathInfo);
    }

    switch (selection) {
      case dialogs.YesNoCancel.yes:
        final bool savedSuccessfully = await handleSaveOnPop();
        if (!savedSuccessfully) {
          return;
        }
        if (mounted && _leavingDirtyForms.isEmpty) {
          Navigator.of(context).pop();
        }
        break;
      case dialogs.YesNoCancel.no:
        widget.formModel.resetForm();
        if (mounted && _leavingDirtyForms.isEmpty) {
          Navigator.of(context).pop();
        }
        break;
      case dialogs.YesNoCancel.cancel:
        break;
    }
  }

  Future<bool> handleSaveOnPop();

  Future<void> _onChanged() async {
    if (FlutterArtist.executor.executingXModuleId != null) {
      return;
    }
    if (widget.formModel._changeEventLocked) {
      return;
    }

    final bool isBuilding = widget.formModel.ui._isWidgetStateBuilding(
      widgetState: this,
    );
    if (!isBuilding) {
      final Map<String, dynamic> currentInstantValues =
          formKey.currentState?.instantValue ?? {};
      await widget.formModel._onChangeFromFormView(
        formKeyInstantValuesInUI: currentInstantValues,
      );
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    if (widget.formModel.effectivePreventUnsavedChangesLoss) {
      return PopScope(
        canPop: !widget.formModel.isDirty(),
        onPopInvokedWithResult: _onPopInvokedWithResult,
        child: _buildFormBuilder(context),
      );
    } else {
      return _buildFormBuilder(context);
    }
  }

  KeyEventResult handleFormMnemonicKeyEvent(
    BuildContext context,
    KeyEvent event,
  ) =>
      KeyEventResult.ignored;

  bool _isCircularFocusTraversal(BuildContext context) {
    final _StageFormViewSwitcherScope? scope =
        _StageFormViewSwitcherScope.maybeOf(context);
    if (scope != null) {
      return scope.circularFocusTraversal;
    }
    return widget.config.circularFocusTraversal;
  }

  Widget _buildFormBuilder(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: (node, event) {
        // 1. Handle Mnemonic Shortcuts first (e.g., Alt+S / Ctrl+S, Alt+U / Ctrl+U)
        final mnemonicResult = handleFormMnemonicKeyEvent(context, event);
        if (mnemonicResult == KeyEventResult.handled) {
          return KeyEventResult.handled;
        }

        // 2. Handle custom Tab / Enter field focus navigation (resolveNextFocus)
        final navResult = _FocusNavDispatcher.handleFormKeyEvent(
          node: node,
          event: event,
          formModel: widget.formModel,
          formState: formKey.currentState,
        );
        if (navResult == KeyEventResult.handled) {
          return KeyEventResult.handled;
        }

        // 3. Fallback: Circular focus traversal within this FormView when resolveNextFocus() returns null
        final bool isCircular = _isCircularFocusTraversal(context);

        if (isCircular &&
            (event is KeyDownEvent || event is KeyRepeatEvent) &&
            event.logicalKey == LogicalKeyboardKey.tab) {
          final HardwareKeyboard keyboard = HardwareKeyboard.instance;
          // Do not intercept Ctrl+Tab / Alt+Tab / Meta+Tab (reserved for region/OS switching)
          if (!keyboard.isControlPressed &&
              !keyboard.isAltPressed &&
              !keyboard.isMetaPressed) {
            final FocusNode? primaryFocus = FocusManager.instance.primaryFocus;
            if (primaryFocus != null && primaryFocus != node) {
              final FocusTraversalPolicy policy =
                  FocusTraversalGroup.maybeOf(context) ??
                      ReadingOrderTraversalPolicy();

              // Sort only focusable descendants inside THIS FormView's `node`
              final List<FocusNode> formFocusNodes = policy
                  .sortDescendants(node.traversalDescendants, primaryFocus)
                  .toList();

              if (formFocusNodes.isNotEmpty) {
                final bool isShiftPressed = keyboard.isShiftPressed;
                if (isShiftPressed && primaryFocus == formFocusNodes.first) {
                  formFocusNodes.last.requestFocus();
                  return KeyEventResult.handled;
                } else if (!isShiftPressed &&
                    primaryFocus == formFocusNodes.last) {
                  formFocusNodes.first.requestFocus();
                  return KeyEventResult.handled;
                }
              }
            }
          }
        }

        return KeyEventResult.ignored;
      },
      child: FormBuilder(
        key: formKey,
        initialValue: widget.formModel._getInitialValuesForFormView(),
        autovalidateMode: widget.formModel._autovalidateModeForFormView,
        onChanged: _onChanged,
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    // if (widget.config.quickSuggestionMode == QuickSuggestionMode.showIfError) {
    //   return Stack(
    //     children: [
    //       _buildAbsorbPointer(),
    //       if (widget.formModel.dataState.isFatalError)
    //         Positioned(
    //           top: 5,
    //           right: 5,
    //           child: _buildQuickSuggestionButtonsBar(context),
    //         ),
    //     ],
    //   );
    // } else {
    //   return _buildAbsorbPointer();
    // }
    return _buildAbsorbPointer();
  }

  Widget _buildAbsorbPointer() {
    return AbsorbPointer(
      absorbing: !widget.formModel.isEnabled(),
      child: widget.build(),
    );
  }

  Widget _buildQuickSuggestionButtonsBar(BuildContext context) {
    return _QuickSuggestionButtonsBar(
      children: [
        if (widget.formModel.formInitialDataReady)
          _QuickSuggestionButton.error(
            tooltip: "Form Error",
            onPressed: () {
              widget.formModel.showFormErrorViewerDialog(context);
            },
          ),
        if (!widget.formModel.formInitialDataReady)
          _QuickSuggestionButton.fatal(
            tooltip: "Form disabled due to error",
            onPressed: () {
              widget.formModel.showFormErrorViewerDialog(context);
            },
          ),
        _QuickSuggestionButton.restore(
          tooltip: "Restore the state before the error",
          onPressed: widget.formModel.formInitialDataReady
              ? () {
                  widget.formModel.showFormErrorViewerDialog(context);
                }
              : null,
        ),
      ],
    );
  }
}
