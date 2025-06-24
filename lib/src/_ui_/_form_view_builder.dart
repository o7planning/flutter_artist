part of '../../flutter_artist.dart';

class _FormViewBuilder extends _RefreshableWidget {
  final FormModel formModel;
  final bool showIconIfError;

  final Widget Function() build;

  const _FormViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.formModel,
    required this.build,
    this.showIconIfError = true,
  });

  @override
  State<StatefulWidget> createState() {
    return _FormViewBuilderState();
  }
}

class _FormViewBuilderState extends _RefreshableWidgetState<_FormViewBuilder> {
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.formModel);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.form;

  @override
  void setBuildingState({required bool isBuilding}) {
    widget.formModel._setFormViewBuildingState(
      widgetState: this,
      isBuilding: isBuilding,
    );
  }

  @override
  void addWidgetState({required bool isShowing}) {
    widget.formModel._addFormWidgetState(
      widgetState: this,
      isShowing: true,
    );
  }

  @override
  void removeWidgetState() {
    widget.formModel._removeFormWidgetState(
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
    _leavingDirtyForms[widget.formModel.id] = widget.formModel;
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
      _leavingDirtyForms.remove(widget.formModel.id);
    }
    switch (selection) {
      case dialogs.YesNoCancel.yes:
        bool success = await widget.formModel.saveForm();
        if (!success) {
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
    if (widget.formModel.block.leaveTheFormSafely) {
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
    bool isBuilding = widget.formModel._isWidgetStateBuilding(
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
    if (widget.showIconIfError) {
      return Stack(
        children: [
          _buildAbsorbPointer(),
          if (widget.formModel.formDataState == DataState.error)
            Positioned(top: 5, right: 5, child: _buildErrorIcon(context)),
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

  Widget _buildErrorIcon(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.deepOrange[50],
      child: IconButton(
        icon: Icon(
          Icons.error,
          size: 16,
          color: Colors.red,
        ),
        onPressed: () {
          widget.formModel.showFormErrorViewerDialog(context);
        },
      ),
    );
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.formModel.shelf);
  }
}
