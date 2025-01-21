part of '../flutter_artist.dart';

class BlockFormWidgetBuilder extends _StatefulWidget {
  final BlockForm blockForm;

  final Widget Function(BlockForm blkForm) build;
  @Deprecated("Chua su dung")
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
  void addWidgetStateListener({required bool isShowing}) {
    widget.blockForm._addWidgetStateListener(
      formWidgetState: this,
      isShowing: true,
    );
  }

  @override
  void removeWidgetStateListener({required _WidgetState thisWidgetState}) {
    widget.blockForm._removeWidgetStateListener(
      formWidgetState: thisWidgetState,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.blockForm._formKey = formKey;
  }

  @override
  Widget buildContent(BuildContext context) {
    __executeAfterBuild();
    //
    return FormBuilder(
      key: formKey,
      initialValue: widget.blockForm.initFormValue(),
      onChanged: () {
        widget.blockForm._onChangeFromFormWidget();
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.blockForm.block.updateControlBarWidgets();
            widget.blockForm.updateAllUIComponents();
          });
        }
      },
      child: AbsorbPointer(
        absorbing: !widget.blockForm.isEnabled(),
        child: widget.build(widget.blockForm),
      ),
    );
  }

  Future<void> __executeAfterBuild() async {
    await Future.delayed(Duration.zero);
    widget.blockForm._afterBuildFormWidget();
  }
}
