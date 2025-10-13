part of '../core.dart';

class FormViewBuilder extends _RefreshableWidget {
  final FormModel formModel;
  final QuickSuggestionMode quickSuggestionMode;

  final Widget Function() build;

  const FormViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.formModel,
    required this.build,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
  });

  @override
  State<StatefulWidget> createState() {
    return _FormViewBuilderState();
  }
}

class _FormViewBuilderState extends _RefreshableWidgetState<FormViewBuilder> {
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.formModel);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.form;

  @override
  void setBuildingState({required bool isBuilding}) {
    widget.formModel.ui._setFormViewBuildingState(
      widgetState: this,
      isBuilding: isBuilding,
    );
  }

  @override
  void addWidgetState({required bool isShowing}) {
    widget.formModel.ui._addFormWidgetState(
      widgetState: this,
      isShowing: isShowing,
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.formModel._formKey = formKey;
  }

  Future<void> _onPopInvokedWithResult(bool didPop, dynamic result) async {
    if (didPop || !widget.formModel.isDirty()) {
      return;
    }
    _leavingDirtyForms[widget.formModel.pathInfo] = widget.formModel;
    //
    dialogs.YesNoCancel selection = dialogs.YesNoCancel.cancel;
    try {
      selection = await dialogs.showYesNoCancelDialog(
        context: context,
        message:
            "Do you want to save changes the [${getClassName(widget.formModel)}] before closing?",
        details: "",
        defaultOption: dialogs.YesNoCancel.yes,
      );
    } finally {
      _leavingDirtyForms.remove(widget.formModel.pathInfo);
    }
    switch (selection) {
      case dialogs.YesNoCancel.yes:
        FormSaveResult result = await widget.formModel.saveForm();
        if (!result.successForAll) {
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
        // Do Nothing
        break;
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    if (widget.formModel.block.config.leaveTheFormSafely) {
      return PopScope(
        // TODO: In Error, check again late.
        canPop: !widget.formModel.isDirty(),
        onPopInvokedWithResult: _onPopInvokedWithResult,
        child: _buildFormBuilder(context),
      );
    } else {
      return _buildFormBuilder(context);
    }
  }

  Future<void> _onChanged() async {
    if (FlutterArtist.executor.executingXShelfId != null) {
      return;
    }
    if (widget.formModel._changeEventLocked) {
      return;
    }
    //
    bool isBuilding = widget.formModel.ui._isWidgetStateBuilding(
      widgetState: this,
    );
    if (!isBuilding) {
      await widget.formModel._onChangeFromFormView();
    }
  }

  FormBuilder _buildFormBuilder(BuildContext context) {
    return FormBuilder(
      key: formKey,
      initialValue: widget.formModel._initialValuesForFormView(),
      autovalidateMode: widget.formModel._autovalidateModeForFormView,
      onChanged: _onChanged,
      child: _build(context),
    );
  }

  Widget _build(BuildContext context) {
    if (widget.quickSuggestionMode == QuickSuggestionMode.showIfError) {
      return Stack(
        children: [
          _buildAbsorbPointer(),
          if (widget.formModel.dataState == DataState.error)
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

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.formModel.shelf);
  }
}
