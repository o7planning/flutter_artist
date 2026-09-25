part of '../core.dart';

abstract class BaseFormViewBuilder<M extends BaseFormModel>
    extends _ContextProviderView {
  final M formModel;
  final QuickSuggestionMode quickSuggestionMode;
  final Widget Function() build;

  const BaseFormViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.formModel,
    required this.build,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
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
  bool get provideScalarContext => false;

  @override
  bool get provideItemContext => true;

  @override
  bool get provideFormContext => true;

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

  /// Handles form discard confirmation when closing the route with dirty changes.
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
        // Do nothing.
        break;
    }
  }

  /// Hook implemented by specific form subclasses to persist data upon exit confirmation.
  Future<bool> handleSaveOnPop();

  /// Guards against simultaneous executor sweeps and race conditions during UI changes.
  Future<void> _onChanged() async {
    if (FlutterArtist.executor.executingXShelfId != null) {
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

  FormBuilder _buildFormBuilder(BuildContext context) {
    return FormBuilder(
      key: formKey,
      initialValue: widget.formModel._getInitialValuesForFormView(),
      autovalidateMode: widget.formModel._autovalidateModeForFormView,
      onChanged: _onChanged,
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (widget.quickSuggestionMode == QuickSuggestionMode.showIfError) {
      return Stack(
        children: [
          _buildAbsorbPointer(),
          if (widget.formModel.dataState.isFatalError)
            Positioned(
              top: 5,
              right: 5,
              child: _buildQuickSuggestionButtonsBar(context),
            ),
        ],
      );
    } else {
      return _buildAbsorbPointer();
    }
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
