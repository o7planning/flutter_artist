part of '../../core.dart';

abstract class BaseFormViewBuilder<M extends BaseFormModel>
    extends _ContextProviderView {
  final M formModel;
  final Widget Function() build;

  @override
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

        // 3. Prevent Enter on single-line TextFields from unfocusing the form
        final enterGuardResult =
            FormFocusTraversalUtils.preventSingleLineEnterUnfocus(event);
        if (enterGuardResult == KeyEventResult.handled) {
          return KeyEventResult.handled;
        }

        // 4. Fallback: Circular focus traversal within this FormView when resolveNextFocus() returns null
        return FormFocusTraversalUtils.handleFormTabTraversal(
          context: context,
          node: node,
          event: event,
          isCircular: _isCircularFocusTraversal(context),
        );
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

  // ***************************************************************************

  Widget _buildBody(BuildContext context) {
    return _buildAbsorbPointer();
  }

  // ***************************************************************************

  Widget _buildAbsorbPointer() {
    return AbsorbPointer(
      absorbing: !widget.formModel.isEnabled(),
      child: widget.build(),
    );
  }

  // ***************************************************************************

  void focusFirstErrorFieldSilently() {
    try {
      __focusFirstErrorField();
    } catch (e, stackTrace) {
      print("Error focusFirstErrorFieldSilently: $e");
      print(stackTrace);
    }
  }

  // ***************************************************************************

  /// Scans the entire form to identify fields with validation errors, sorts them
  /// according to their visual reading order (top-to-bottom, left-to-right),
  /// and smoothly scrolls to and focuses the first invalid field.
  void __focusFirstErrorField() {
    final formState = formKey.currentState;
    if (formState == null) return;

    final List<FocusNode> errorNodes = [];
    final Map<FocusNode, BuildContext> nodeContexts = {};

    // 1. Filter out invalid fields and resolve their actual focusable descendant FocusNodes.
    for (final field in formState.fields.values) {
      if (field.hasError) {
        final FocusNode? node = __resolveFieldFocusNode(field);
        if (node != null && node.canRequestFocus) {
          errorNodes.add(node);
          nodeContexts[node] = field.context;
        }
      }
    }
    if (errorNodes.isEmpty) return;

    // 2. Sort the error nodes based on their visual arrangement on the screen
    // to ensure the focus jumps to the visually "first" error, regardless of
    // the internal registration order within flutter_form_builder's map.
    final FocusTraversalPolicy policy =
        FocusTraversalGroup.maybeOf(context) ?? ReadingOrderTraversalPolicy();

    final FocusNode scopeNode = FocusScope.of(context);
    final List<FocusNode> sortedErrorNodes =
        policy.sortDescendants(errorNodes, scopeNode).toList();

    // 3. Scroll to the first errored field and request focus.
    if (sortedErrorNodes.isNotEmpty) {
      final FocusNode targetNode = sortedErrorNodes.first;
      final BuildContext? targetContext = nodeContexts[targetNode];

      if (targetContext != null && targetContext.mounted) {
        Scrollable.ensureVisible(
          targetContext,
          alignment: 0.1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }

      // Defer the focus request by one frame to allow the Scrollable animation
      // to initialize properly before shifting the input focus.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (targetNode.context != null && targetNode.context!.mounted) {
          targetNode.requestFocus();
        }
      });
    }
  }

  // ***************************************************************************

  /// Resolves the actual focusable [FocusNode] owned by [field].
  ///
  /// Checks [FormBuilderFieldState.effectiveFocusNode] first, and falls back to
  /// searching descendant [Focus] widgets inside [field.context].
  FocusNode? __resolveFieldFocusNode(
    FormBuilderFieldState<dynamic, dynamic> field,
  ) {
    final FocusNode effectiveNode = field.effectiveFocusNode;
    if (effectiveNode.canRequestFocus) {
      return effectiveNode;
    }

    if (!field.context.mounted) return null;

    FocusNode? foundDescendant;
    void visitor(Element element) {
      if (foundDescendant != null) return;
      final Widget w = element.widget;
      if (w is Focus && w.focusNode != null && w.focusNode!.canRequestFocus) {
        foundDescendant = w.focusNode;
        return;
      }
      element.visitChildren(visitor);
    }

    field.context.visitChildElements(visitor);
    return foundDescendant;
  }
}
