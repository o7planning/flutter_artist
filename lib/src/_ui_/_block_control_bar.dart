part of '../../flutter_artist.dart';

class BlockControlBar extends _RefreshableWidget {
  final EdgeInsets padding;
  final Block block;
  final bool showRefreshButton;
  final bool showQueryButton;
  final bool showCreateButton;
  final bool showSaveButton;
  final bool showDeleteButton;
  final bool showFormInfoButton;
  final bool showBackButton;
  final bool showFilterCriteriaButton;

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
    this.showFilterCriteriaButton = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _BlockControlBarState();
  }
}

class _BlockControlBarState extends _RefreshableWidgetState<BlockControlBar> {
  static const double _dividerHeight = 20;
  final Color _dividerColor = Colors.indigo.withAlpha(80);

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.controlBar;

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  void addWidgetState({required bool isShowing}) {
    widget.block._addControlBarWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeWidgetState() {
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
    Actionable deleteActionable = widget.block.canDeleteCurrentItem();
    Actionable createActionable = widget.block.canCreateItem();
    //
    return _buildBreadCrumb(
      children: [
        if (widget.block.formModel != null && widget.showCreateButton)
          _ControlBarButton(
            tooltip: "Create",
            iconData: _formCreateIconData,
            onAction: widget.block.isPreparingFormCreation,
            onPressed: widget.showCreateButton && createActionable.yes
                ? () {
                    _prepareFormToCreateItem(widget.block);
                  }
                : null,
          ),
        if (widget.showDeleteButton)
          _ControlBarButton(
            tooltip: "Delete",
            iconData: _formDeleteIconData,
            iconColor: widget.showDeleteButton && deleteActionable.yes
                ? Colors.red
                : Colors.black26,
            onAction: widget.block.isDeleting,
            onPressed: widget.showDeleteButton && deleteActionable.yes
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
            if (widget.block.formModel != null &&
                (loggedInUser?.isSystemUser ?? false))
              Tooltip(
                message:
                    "${widget.block.formModel!.formMode.tooltip} [${getClassName(widget.block)}]",
                child: Icon(
                  widget.block.formModel!.formMode == FormMode.none
                      ? _formNoneModeIconData
                      : widget.block.formModel!.formMode == FormMode.creation
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
    Actionable refreshActionable = widget.block.canRefreshCurrentItem();
    Actionable queryActionable = widget.block.canQuery();
    //
    return _buildBreadCrumb(
      children: [
        if (widget.showRefreshButton)
          _ControlBarButton(
            tooltip: "Refresh Current Item",
            iconData: _formRefreshIconData,
            onAction: widget.block.isRefreshingCurrentItem,
            onPressed: widget.showRefreshButton && refreshActionable.yes
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
            onPressed: widget.showQueryButton && queryActionable.yes
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
    Actionable saveActionable = widget.block.canSaveForm();
    Actionable resetActionable = widget.block.canResetForm();
    //
    return _buildBreadCrumb(
      children: [
        if (widget.block.formModel != null && widget.showSaveButton)
          _ControlBarButton(
            tooltip: "Save",
            iconData: _formSaveIconData,
            onAction: widget.block.__isSaving,
            onPressed: widget.showSaveButton && saveActionable.yes
                ? () {
                    _saveForm(widget.block);
                  }
                : null,
          ),
        if (widget.block.formModel != null && widget.showSaveButton)
          _ControlBarButton(
            tooltip: "Reset",
            iconData: _formCleanIconData,
            onAction: false,
            onPressed: widget.showSaveButton && resetActionable.yes
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
    Actionable formInfoActionable = widget.block.canShowFormInfo();
    //
    return _buildBreadCrumb(
      children: [
        if (widget.showFilterCriteriaButton &&
            widget.block.canShowFilterCriteria())
          _ControlBarButton(
            tooltip: "Current Filter Criteria of ${getClassName(widget.block)}",
            iconData: _filterCriteriaIconData,
            onAction: false,
            onPressed: widget.showFilterCriteriaButton
                ? () {
                    showBlockFilterCriteriaDialog(
                      context: context,
                      block: widget.block,
                    );
                  }
                : null,
          ),
        if (widget.showFormInfoButton && formInfoActionable.yes)
          _ControlBarButton(
            tooltip: "Form Data",
            iconData: _blockIconData,
            onAction: false,
            onPressed: widget.showFormInfoButton
                ? () {
                    _showFormInfo(context, widget.block);
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
    await widget.block.formModel?.saveForm();
  }

  Future<void> _doDelete(Block block) async {
    await widget.block.deleteCurrentItem();
  }

  Future<void> _prepareFormToCreateItem(Block block) async {
    await widget.block.prepareFormToCreateItem(navigate: null);
  }

  void _resetForm(Block block) {
    widget.block.formModel?.resetForm();
  }

  Future<void> _refreshCurrentItem(Block block) async {
    await widget.block.refreshCurrentItem();
  }

  Future<void> _queryBlock(Block block) async {
    await widget.block.query();
  }

  void _showFormInfo(BuildContext context, Block block) {
    _showFormInfoDialog(
      context: context,
      locationInfo: getClassName(widget.ownerClassInstance),
      formModel: block.formModel!,
    );
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.block.shelf);
  }

  @override
  void executeAfterBuild() {
    // Do nothing.
  }

  @override
  void setBuildingState({required bool isBuilding}) {
    //
  }
}
