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
  late final String keyId;

  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  String get locationInfo => getClassName(widget.ownerClassInstance);

  @override
  String get description {
    return widget.description == null || widget.description!.trim().isEmpty
        ? "${getClassName(widget.blockForm)} (BlockForm)"
        : widget.description!;
  }

  @override
  WidgetStateType get type => WidgetStateType.form;

  @override
  void refreshState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    keyId = _generateVisibilityDetectorId(
      prefix: getClassName(widget.blockForm),
    );
    widget.blockForm._addWidgetStateListener(
      formWidgetState: this,
      isShowing: true,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.blockForm._formKey = formKey;
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(keyId),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        _addWidgetStateListener(isShowing: visiblePercentage > 0);
      },
      child: showMode == ShowMode.production
          ? _buildMain()
          : _DevContainer(
              child: _buildMain(),
            ),
    );
  }

  Widget _buildMain() {
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

  void _addWidgetStateListener({required bool isShowing}) {
    widget.blockForm._addWidgetStateListener(
      formWidgetState: this,
      isShowing: isShowing,
    );
  }
}
