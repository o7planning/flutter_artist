part of '../flutter_artist.dart';

class BlockControlBar extends StatefulWidget {
  final EdgeInsets padding;
  final Block block;
  final bool showRefreshButton;
  final bool showQueryButton;
  final bool showCreateButton;
  final bool showSaveButton;
  final bool showDeleteButton;
  final bool showFormInfoButton;
  final bool showBackButton;

  final String? description;

  ///
  /// The owner class instance.
  ///
  final Object ownerClassInstance;

  const BlockControlBar({
    super.key,
    this.padding = const EdgeInsets.all(5),
    required this.description,
    required this.ownerClassInstance,
    required this.block,
    required this.showRefreshButton,
    required this.showQueryButton,
    required this.showCreateButton,
    required this.showSaveButton,
    required this.showDeleteButton,
    required this.showBackButton,
    required this.showFormInfoButton,
  });

  @override
  State<StatefulWidget> createState() {
    return _BlockControlBarState();
  }
}

class _BlockControlBarState extends _WidgetState<BlockControlBar> {
  static const double _dividerHeight = 20;
  final Color _dividerColor = Colors.indigo.withAlpha(80);

  late final String keyId;

  @override
  String get description {
    return widget.description == null || widget.description!.trim().isEmpty
        ? "${getClassName(widget.block)} (Control bar)"
        : widget.description!;
  }

  @override
  String get locationInfo => getClassName(widget.ownerClassInstance);

  @override
  WidgetStateType get type => WidgetStateType.controlBar;

  @override
  void refreshState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    keyId = _generateVisibilityDetectorId(
        prefix: "ControlBar-${getClassName(widget.block)}");
    _addControlBarWidgetStateListener(isShowing: true);
  }

  @override
  void dispose() {
    super.dispose();
    widget.block._removeControlBarWidgetStateListener(
      formWidgetState: this,
    );
  }

  void _addControlBarWidgetStateListener({required bool isShowing}) {
    widget.block._addControlBarWidgetStateListener(
      formWidgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(keyId),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        _addControlBarWidgetStateListener(isShowing: visiblePercentage > 0);
      },
      child: showMode == ShowMode.production
          ? _buildMain()
          : _DevContainer(
              child: _buildMain(),
            ),
    );
  }

  Widget _buildMain() {
    return _CustomAppContainer.bar(
      padding: widget.padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLeftButtons(context),
          const Spacer(),
          _buildRightButtons(context),
        ],
      ),
    );
  }

  Widget? _buildBreadCrumb({
    required List<Widget> children,
    required Widget divider,
    required BreadCrumbOverflow overflow,
  }) {
    return children.isEmpty
        ? null
        : BreadCrumb(
            divider: divider,
            overflow: overflow,
            items: children
                .map(
                  (child) => BreadCrumbItem(content: child),
                )
                .toList(),
          );
  }

  Widget? _buildLeft2Buttons() {
    return _buildBreadCrumb(
      children: [
        if (widget.block.blockForm != null && widget.showCreateButton)
          _ControlBarButton(
            tooltip: "Create",
            iconData: _formCreateIconData,
            onAction: widget.block.isPreparingFormCreation,
            onPressed: widget.showCreateButton && widget.block.canCreate()
                ? () {
                    _prepareToCreate(widget.block);
                  }
                : null,
          ),
        if (widget.showDeleteButton)
          _ControlBarButton(
            tooltip: "Delete",
            iconData: _formDeleteIconData,
            iconColor:
                widget.showDeleteButton && widget.block.canDeleteCurrentItem()
                    ? Colors.red
                    : Colors.black26,
            onAction: widget.block.isDeleting,
            onPressed:
                widget.showDeleteButton && widget.block.canDeleteCurrentItem()
                    ? () {
                        _doDelete(widget.block);
                      }
                    : null,
          ),
      ],
      divider: _buildSpaceSeparator(),
      overflow: ScrollableOverflow(
        keepLastDivider: false,
        reverse: false,
        direction: Axis.horizontal,
      ),
    );
  }

  Widget _buildLeftButtons(BuildContext context) {
    ILoggedInUser? loggedInUser = FlutterArtist.loggedInUser;
    Widget? left2 = _buildLeft2Buttons();
    return _buildBreadCrumb(
          overflow: ScrollableOverflow(
            keepLastDivider: false,
            reverse: false,
            direction: Axis.horizontal,
          ),
          children: [
            if (widget.showBackButton)
              _ControlBarButton(
                tooltip: "Back",
                iconData: _formBackIconData,
                onAction: false,
                onPressed: widget.showBackButton ? _back : null,
              ),
            if (loggedInUser?.isSystemUser ?? false)
              Tooltip(
                message:
                    "${widget.block.formMode.tooltip} [${getClassName(widget.block)}]",
                child: Icon(
                  widget.block.formMode == FormMode.none
                      ? _formNoneModeIconData
                      : widget.block.formMode == FormMode.creation
                          ? _formCreationModeIconData
                          : _formEditModeIconData,
                  size: _ControlBarButton.iconSize,
                ),
              ),
            if (left2 != null) left2
          ],
          divider: _buildVerticalSeparator(),
        ) ??
        const SizedBox();
  }

  Widget _buildRightButtons(BuildContext context) {
    Widget? right1 = _buildRight1Buttons(context);
    Widget? right2 = _buildRight2Buttons(context);
    Widget? right3 = _buildRight3Buttons(context);
    //
    return _buildBreadCrumb(
          overflow: ScrollableOverflow(
            keepLastDivider: false,
            reverse: false,
            direction: Axis.horizontal,
          ),
          children: [
            if (right1 != null) right1,
            if (right2 != null) right2,
            if (right3 != null) right3,
          ],
          divider: _buildVerticalSeparator(),
        ) ??
        const SizedBox();
  }

  Widget? _buildRight1Buttons(BuildContext context) {
    return _buildBreadCrumb(
      children: [
        if (widget.showRefreshButton)
          _ControlBarButton(
            tooltip: "Refresh Current Item",
            iconData: _formRefreshIconData,
            onAction: widget.block.isRefreshingCurrentItem,
            onPressed: widget.showRefreshButton && widget.block.canRefresh()
                ? () {
                    _refreshForm(widget.block);
                  }
                : null,
          ),
        if (widget.showQueryButton)
          _ControlBarButton(
            tooltip: "Re Query",
            iconData: _formQueryIconData,
            onAction: widget.block.isQuerying,
            onPressed: widget.showQueryButton && widget.block.canQuery()
                ? () {
                    _queryBlock(widget.block);
                  }
                : null,
          ),
      ],
      divider: _buildSpaceSeparator(),
      overflow: ScrollableOverflow(
        keepLastDivider: false,
        reverse: false,
        direction: Axis.horizontal,
      ),
    );
  }

  Widget? _buildRight2Buttons(BuildContext context) {
    return _buildBreadCrumb(
      children: [
        if (widget.block.blockForm != null && widget.showSaveButton)
          _ControlBarButton(
            tooltip: "Save",
            iconData: _formSaveIconData,
            onAction: widget.block.__isSaving,
            onPressed: widget.showSaveButton &&
                    widget.block.blockForm != null &&
                    widget.block.blockForm!.isDirty()
                ? () {
                    _saveForm(widget.block);
                  }
                : null,
          ),
        if (widget.block.blockForm != null && widget.showSaveButton)
          _ControlBarButton(
            tooltip: "Reset",
            iconData: _formCleanIconData,
            onAction: false,
            onPressed: widget.showSaveButton &&
                    widget.block.blockForm != null &&
                    widget.block.blockForm!.isDirty()
                ? () {
                    _resetForm(widget.block);
                  }
                : null,
          ),
      ],
      divider: _buildSpaceSeparator(),
      overflow: ScrollableOverflow(
        keepLastDivider: false,
        reverse: false,
        direction: Axis.horizontal,
      ),
    );
  }

  Widget? _buildRight3Buttons(BuildContext context) {
    ILoggedInUser? loggedInUser = FlutterArtist.loggedInUser;
    return _buildBreadCrumb(
      children: [
        if (widget.block.blockForm != null &&
            widget.showFormInfoButton &&
            (loggedInUser?.isSystemUser ?? false))
          _ControlBarButton(
            tooltip: "Form Data",
            iconData: _blockIconData,
            onAction: false,
            onPressed: widget.showFormInfoButton
                ? () {
                    _showFormDataInfo(context, widget.block);
                  }
                : null,
          ),
      ],
      divider: _buildSpaceSeparator(),
      overflow: ScrollableOverflow(
        keepLastDivider: false,
        reverse: false,
        direction: Axis.horizontal,
      ),
    );
  }

  Widget _buildVerticalSeparator() {
    return SizedBox(
      height: _dividerHeight,
      child: VerticalDivider(color: _dividerColor),
    );
  }

  Widget _buildSpaceSeparator() {
    return const SizedBox(width: 5);
  }

  void _back() {
    FlutterArtist.adapter.navigationBack();
  }

  void _saveForm(Block block) {
    widget.block.blockForm?.saveForm();
  }

  void _doDelete(Block block) {
    widget.block.deleteCurrentItem();
  }

  void _prepareToCreate(Block block) {
    widget.block.prepareToCreate(navigate: null);
  }

  void _resetForm(Block block) {
    widget.block.blockForm?.resetForm();
  }

  void _refreshForm(Block block) {
    widget.block.refreshCurrentItem();
  }

  void _queryBlock(Block block) {
    widget.block.query();
  }

  void _showFormDataInfo(BuildContext context, Block block) {
    _showFromDataInfoDialog(
      context: context,
      locationInfo: getClassName(widget.ownerClassInstance),
      blockForm: block.blockForm!,
    );
  }
}
