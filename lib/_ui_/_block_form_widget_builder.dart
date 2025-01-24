part of '../flutter_artist.dart';

class BlockFormWidgetBuilder extends _StatefulWidget {
  final BlockForm blockForm;

  final Widget Function() build;

  @Deprecated("Not use")
  final Function()? onAfterBuild;

  const BlockFormWidgetBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.blockForm,
    required this.build,
    this.onAfterBuild,
  });

  @override
  State<StatefulWidget> createState() {
    return _BlockFormWidgetBuilderState();
  }
}

class _BlockFormWidgetBuilderState
    extends _WidgetState<BlockFormWidgetBuilder> {
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.blockForm);
  }

  @override
  WidgetStateType get type => WidgetStateType.form;

  @override
  void addFilterFragmentWidgetState({required bool isShowing}) {
    widget.blockForm._addFormWidgetState(
      widgetState: this,
      isShowing: true,
    );
  }

  @override
  void removeFilterFragmentWidgetState() {
    widget.blockForm._removeFormWidgetState(
      widgetState: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.blockForm._formKey = formKey;
  }

Future<void> _onPopInvokedWithResult(bool didPop, dynamic result) async {
  if (didPop || !widget.blockForm.isDirty()) {
    return;
  }
  //
  dialogs.YesNoCancel selection = await dialogs.showYesNoCancelDialog(
    context: context,
    message:
        "Do you want to save changes the ${getClassName(widget.blockForm)} before closing?",
    details: "",
    defaultOption: YesNoCancel.yes,
  );
  switch (selection) {
    case dialogs.YesNoCancel.yes:
      bool success = await widget.blockForm.saveForm();
      if (!success) {
        return;
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
      break;
    case dialogs.YesNoCancel.no:
      widget.blockForm.resetForm();
      if (mounted) {
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
    __executeAfterBuild();
    //
    if (widget.blockForm.block.leaveTheFormSafely) {
      return PopScope(
        // TODO: In Error, check again late.
        canPop: !widget.blockForm.isDirty(),
        onPopInvokedWithResult: _onPopInvokedWithResult,
        child: _buildFormBuilder(),
      );
    } else {
      return _buildFormBuilder();
    }
  }

  FormBuilder _buildFormBuilder() {
    return FormBuilder(
      key: formKey,
      initialValue: widget.blockForm.initFormValue(),
      onChanged: () {
        widget.blockForm._onChangeFromFormWidget();
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.blockForm.shelf.updateAllUIComponents();
          });
        }
      },
      child: AbsorbPointer(
        absorbing: !widget.blockForm.isEnabled(),
        child: widget.build(),
      ),
    );
  }

  Future<void> __executeAfterBuild() async {
    // IMPORTANT: Do not remove below line:
    await Future.delayed(Duration.zero);
    //
    widget.blockForm._afterBuildFormWidget();
  }
}
