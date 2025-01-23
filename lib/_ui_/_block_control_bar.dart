part of '../flutter_artist.dart';

class BlockControlBar extends _StatefulWidget {
  final EdgeInsets padding;
  final Block block;
  final bool showRefreshButton;
  final bool showQueryButton;
  final bool showCreateButton;
  final bool showSaveButton;
  final bool showDeleteButton;
  final bool showFormInfoButton;
  final bool showBackButton;

  const BlockControlBar({
    super.key,
    this.padding = const EdgeInsets.all(5),
    required super.ownerClassInstance,
    required super.description,
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

  @override
  WidgetStateType get type => WidgetStateType.controlBar;

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  void addFilterFragmentWidgetState({required bool isShowing}) {
    widget.block._addControlBarWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeFilterFragmentWidgetState() {
    widget.block._removeControlBarWidgetState(
      widgetState: this,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
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
            onPressed: widget.showCreateButton && widget.block.canCreateItem()
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
                onPressed:
                    widget.showBackButton && Navigator.of(context).canPop()
                        ? () {
                            _back(context);
                          }
                        : null,
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
            onPressed:
                widget.showRefreshButton && widget.block.canRefreshCurrentItem()
                    ? () {
                        _refreshCurrentItem(widget.block);
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
            onPressed: widget.showSaveButton && widget.block.canSaveForm()
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
            onPressed: widget.showSaveButton && widget.block.canResetForm()
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

  Future<void> _back(BuildContext context) async {
    bool canPop = await Navigator.of(context).maybePop();
  }

  Future<void> _saveForm(Block block) async {
    await widget.block.blockForm?.saveForm();
  }

  Future<void> _doDelete(Block block) async {
    await widget.block.deleteCurrentItem();
  }

  Future<void> _prepareToCreate(Block block) async {
    await widget.block.prepareToCreate(navigate: null);
  }

  void _resetForm(Block block) {
    widget.block.blockForm?.resetForm();
  }

  Future<void> _refreshCurrentItem(Block block) async {
    await widget.block.refreshCurrentItem();
  }

  Future<void> _queryBlock(Block block) async {
    await widget.block.query();
  }

  void _showFormDataInfo(BuildContext context, Block block) {
    _showFromDataInfoDialog(
      context: context,
      locationInfo: getClassName(widget.ownerClassInstance),
      blockForm: block.blockForm!,
    );
  }
}
