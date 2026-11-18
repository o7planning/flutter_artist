part of '../../core.dart';

/// Builds context-aware [MnemonicShortcutDescriptor] lists tailored to a
/// specific [FocusRegionType].
class _KeyboardShortcutCatalog {
  /// Returns the ordered list of [MnemonicShortcutDescriptor] entries for [regionType].
  static List<MnemonicShortcutDescriptor> buildEntriesForRegion(
    FocusRegionType regionType,
  ) {
    final List<MnemonicShortcutDescriptor> entries = [];

    // 1. Domain & CRUD Actions based on region family (highest priority)
    switch (regionType) {
      case FocusRegionType.blockItemsView:
      case FocusRegionType.blockFormView:
      case FocusRegionType.blockItemDetailView:
      case FocusRegionType.blockSectionView:
        entries.addAll(
          [
            MnemonicShortcut.create.toDescriptor(),
            MnemonicShortcut.edit.toDescriptor(),
            MnemonicShortcut.save.toDescriptor(),
            MnemonicShortcut.delete.toDescriptor(),
            MnemonicShortcut.refresh.toDescriptor(),
            MnemonicShortcut.query.toDescriptor(),
            MnemonicShortcut.reset.toDescriptor(),
            MnemonicShortcut.debugFilterModel.toDescriptor(),
            MnemonicShortcut.debugFilterCriteria.toDescriptor(
              customActionLabel: 'Inspect Filter Criteria',
            ),
            MnemonicShortcut.debugFormModel.toDescriptor(),
          ],
        );
        break;

      case FocusRegionType.scalarValueView:
        entries.addAll(
          [
            MnemonicShortcut.query.toDescriptor(),
            MnemonicShortcut.refresh.toDescriptor(
              customActionLabel: 'Refresh Scalar Value',
            ),
            MnemonicShortcut.debugFilterModel.toDescriptor(),
            MnemonicShortcut.debugFilterCriteria.toDescriptor(),
          ],
        );
        break;

      case FocusRegionType.filterPanel:
        entries.addAll(
          [
            MnemonicShortcut.debugFilterModel.toDescriptor(
              customActionLabel: 'Inspect Filter Model',
            ),
            MnemonicShortcut.debugFilterCriteria.toDescriptor(),
          ],
        );
        break;

      case FocusRegionType.taskView:
      case FocusRegionType.taskFormView:
        entries.addAll(
          [
            MnemonicShortcut.submit.toDescriptor(
              customActionLabel: 'Submit Task',
            ),
            MnemonicShortcut.restart.toDescriptor(
              customActionLabel: 'Restart Task',
            ),
            MnemonicShortcut.reset.toDescriptor(
              customActionLabel: 'Reset Task Form',
            ),
            MnemonicShortcut.debugFormModel.toDescriptor(),
          ],
        );
        break;

      case FocusRegionType.prozessView:
      case FocusRegionType.prozessStagesSwitcher:
      case FocusRegionType.stageView:
      case FocusRegionType.stageFormView:
        entries.addAll(
          [
            MnemonicShortcut.submit.toDescriptor(
              customActionLabel: 'Submit Viewing Stage',
            ),
            MnemonicShortcut.reset.toDescriptor(
              customActionLabel: 'Reset Viewing Stage Form',
            ),
            MnemonicShortcut.moveToNextStage.toDescriptor(),
            MnemonicShortcut.moveToPreviousStage.toDescriptor(),
            MnemonicShortcut.restart.toDescriptor(
              customActionLabel: 'Restart Viewing Stage',
            ),
            MnemonicShortcut.restartAll.toDescriptor(),
            MnemonicShortcut.cancel.toDescriptor(),
            MnemonicShortcut.debugFormModel.toDescriptor(),
            MnemonicShortcut.debugInspector.toDescriptor(),
          ],
        );
        break;

      default:
        break;
    }

    // 2. Intra-region Field & Item Navigation
    switch (regionType) {
      case FocusRegionType.blockItemsView:
        entries.addAll([
          const MnemonicShortcutDescriptor(
            group: MnemonicShortcutGroup.fieldAndItemNavigation,
            actionLabel: 'Select Next / Previous Item (Arrow)',
            keyCaps: ['↓', '↑'],
          ),
          MnemonicShortcut.nextItem.toDescriptor(),
          MnemonicShortcut.previousItem.toDescriptor(),
          MnemonicShortcut.nextPage.toDescriptor(),
          MnemonicShortcut.previousPage.toDescriptor(),
          MnemonicShortcut.firstPage.toDescriptor(),
          MnemonicShortcut.loadMore.toDescriptor(),
        ]);
        break;

      case FocusRegionType.blockFormView:
      case FocusRegionType.blockItemDetailView:
        entries.addAll([
          const MnemonicShortcutDescriptor(
            group: MnemonicShortcutGroup.fieldAndItemNavigation,
            actionLabel: 'Move to Next / Previous Field',
            keyCaps: ['Tab', 'Shift + Tab'],
          ),
          const MnemonicShortcutDescriptor(
            group: MnemonicShortcutGroup.fieldAndItemNavigation,
            actionLabel: 'Advance Focus via resolveNextFocus()',
            keyCaps: ['Enter'],
          ),
          MnemonicShortcut.nextItem.toDescriptor(
            customActionLabel: 'Select Next Record (Fn + ↓)',
          ),
          MnemonicShortcut.previousItem.toDescriptor(
            customActionLabel: 'Select Previous Record (Fn + ↑)',
          ),
          MnemonicShortcut.nextPage.toDescriptor(),
          MnemonicShortcut.previousPage.toDescriptor(),
        ]);
        break;

      case FocusRegionType.taskFormView:
      case FocusRegionType.stageFormView:
      case FocusRegionType.filterPanel:
        entries.addAll([
          const MnemonicShortcutDescriptor(
            group: MnemonicShortcutGroup.fieldAndItemNavigation,
            actionLabel: 'Move to Next / Previous Field',
            keyCaps: ['Tab', 'Shift + Tab'],
          ),
          const MnemonicShortcutDescriptor(
            group: MnemonicShortcutGroup.fieldAndItemNavigation,
            actionLabel: 'Advance Focus via resolveNextFocus()',
            keyCaps: ['Enter'],
          ),
        ]);
        break;

      default:
        break;
    }

    // 3. Dynamically discovered [ControlMnemonic] buttons on screen
    final List<ControlMnemonicState> mountedControls = _MnemonicDispatcher
        ._registeredControls
        .where((c) => c.mounted && c.isActionEnabled)
        .toList();

    for (final control in mountedControls) {
      final List<String> caps = control.modifier == MnemonicModifier.none
          ? [control.charKey]
          : [
              ...control.modifier.label.split('+').map((e) => e.trim()),
              control.charKey,
            ];
      final String scopeSuffix =
          control.scope != null ? ' (${control.scope.runtimeType})' : '';
      entries.add(
        MnemonicShortcutDescriptor(
          group: MnemonicShortcutGroup.customControls,
          actionLabel: 'Trigger Screen Control$scopeSuffix',
          keyCaps: caps,
        ),
      );
    }

    // 4. Global & Region Navigation (always available at the bottom)
    entries.addAll(
      [
        MnemonicShortcut.locateRegion.toDescriptor(),
        MnemonicShortcutDescriptor(
          group: MnemonicShortcutGroup.globalNavigation,
          actionLabel: 'Next View Region',
          keyCaps: MnemonicRegionDirection.next.keyCaps,
        ),
        MnemonicShortcutDescriptor(
          group: MnemonicShortcutGroup.globalNavigation,
          actionLabel: 'Previous View Region',
          keyCaps: MnemonicRegionDirection.previous.keyCaps,
        ),
        const MnemonicShortcutDescriptor(
          group: MnemonicShortcutGroup.globalNavigation,
          actionLabel: 'Open Keyboard Shortcuts Help',
          keyCaps: ['F1'],
        ),
        MnemonicShortcut.back.toDescriptor(),
      ],
    );

    return entries;
  }
}

/// Modal dialog displaying context-sensitive keyboard shortcuts for the active
/// [ActiveFocusRegion], or allowing the user to browse shortcuts by [FocusRegionType].
class KeyboardShortcutsDialog extends StatefulWidget {
  /// The region that was focused when the dialog was opened, if any.
  final ActiveFocusRegion? initialActiveRegion;

  const KeyboardShortcutsDialog({
    this.initialActiveRegion,
    super.key,
  });

  @override
  State<KeyboardShortcutsDialog> createState() =>
      _KeyboardShortcutsDialogState();

  /// Opens [KeyboardShortcutsDialog] while preserving the caller's focus state.
  ///
  /// Automatically restores focus to the previously active leaf widget (or its
  /// enclosing [_FocusableViewRegion]) once the dialog is dismissed.
  static Future<void> show({BuildContext? context}) async {
    final BuildContext targetContext = context ?? FlutterArtistCore.context;

    // Capture focus state before the dialog route pushes on top.
    final ActiveFocusRegion? activeRegion =
        FlutterArtist.focusTracker.currentRegion;
    final _FocusableViewRegionState? savedRegionState =
        _RegionDispatcher.currentlyFocusedRegion;
    final FocusNode? savedLeafNode = FocusManager.instance.primaryFocus;

    await showDialog<void>(
      context: targetContext,
      builder: (BuildContext ctx) {
        return KeyboardShortcutsDialog(
          initialActiveRegion: activeRegion,
        );
      },
    );

    // Restore focus cleanly after the DialogRoute finishes unmounting.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (savedLeafNode != null &&
          savedLeafNode.context != null &&
          savedLeafNode.context!.mounted &&
          savedLeafNode.canRequestFocus) {
        savedLeafNode.requestFocus();
        return;
      }

      if (savedRegionState != null && savedRegionState.mounted) {
        savedRegionState.requestRegionFocus();
      }
    });
  }
}

class _KeyboardShortcutsDialogState extends State<KeyboardShortcutsDialog> {
  static const List<FocusRegionType> _selectableRegionTypes = [
    FocusRegionType.blockItemsView,
    FocusRegionType.blockFormView,
    FocusRegionType.scalarValueView,
    FocusRegionType.filterPanel,
    FocusRegionType.blockItemDetailView,
    FocusRegionType.taskFormView,
    FocusRegionType.stageFormView,
    FocusRegionType.prozessView,
  ];

  late FocusRegionType _selectedRegionType;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _selectedRegionType = widget.initialActiveRegion?.regionType ??
        FocusRegionType.blockItemsView;
    _searchFocusNode = FocusNode(
      debugLabel: 'ShortcutsSearchFocus',
      onKeyEvent: _handleScrollKeyEvent,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// Handles keyboard scrolling (`ArrowUp`, `ArrowDown`, `PageUp`, `PageDown`,
  /// `Home`, `End`) even while focus resides inside the search [TextField].
  KeyEventResult _handleScrollKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (!_scrollController.hasClients) {
      return KeyEventResult.ignored;
    }

    final ScrollPosition pos = _scrollController.position;
    final LogicalKeyboardKey key = event.logicalKey;
    const double lineStep = 48.0;
    final double pageStep = (pos.viewportDimension * 0.85).clamp(120.0, 600.0);

    final bool isEditingSearchText =
        FocusManager.instance.primaryFocus == _searchFocusNode &&
            _searchController.text.isNotEmpty;

    double? targetOffset;
    if (key == LogicalKeyboardKey.arrowDown) {
      targetOffset = (pos.pixels + lineStep).clamp(0.0, pos.maxScrollExtent);
    } else if (key == LogicalKeyboardKey.arrowUp) {
      targetOffset = (pos.pixels - lineStep).clamp(0.0, pos.maxScrollExtent);
    } else if (key == LogicalKeyboardKey.pageDown) {
      targetOffset = (pos.pixels + pageStep).clamp(0.0, pos.maxScrollExtent);
    } else if (key == LogicalKeyboardKey.pageUp) {
      targetOffset = (pos.pixels - pageStep).clamp(0.0, pos.maxScrollExtent);
    } else if (key == LogicalKeyboardKey.home && !isEditingSearchText) {
      targetOffset = 0.0;
    } else if (key == LogicalKeyboardKey.end && !isEditingSearchText) {
      targetOffset = pos.maxScrollExtent;
    }

    if (targetOffset != null) {
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
      );
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final bool hasActiveContext = widget.initialActiveRegion != null;

    return FaDialog(
      titleText: "Keyboard Shortcuts",
      contentPadding: const EdgeInsets.all(12),
      preferredContentWidth: 640,
      preferredContentHeight: 480,
      content: Focus(
        onKeyEvent: _handleScrollKeyEvent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildContextAndSearchHeader(context, hasActiveContext),
            const Divider(height: 16),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: _buildShortcutList(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextAndSearchHeader(
    BuildContext context,
    bool hasActiveContext,
  ) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: [
        // Left: Context badge or Region Type selector dropdown
        Expanded(
          flex: 3,
          child: hasActiveContext
              ? _buildActiveContextBadge(context)
              : _buildRegionSelectorDropdown(context),
        ),
        const SizedBox(width: 10),
        // Right: Quick search filter (autofocused when the dialog opens)
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 32,
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              autofocus: true,
              style: const TextStyle(fontSize: 12.5),
              decoration: InputDecoration(
                hintText: 'Filter shortcuts...',
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: theme.hintColor,
                ),
                prefixIcon: const Icon(Icons.search, size: 16),
                suffixIcon: _searchQuery.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                          _searchFocusNode.requestFocus();
                        },
                        child: const Icon(Icons.close, size: 14),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                isDense: true,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value.trim().toLowerCase());
                if (_scrollController.hasClients) {
                  _scrollController.jumpTo(0);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveContextBadge(BuildContext context) {
    final ActiveFocusRegion region = widget.initialActiveRegion!;
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.my_location, size: 14, color: colors.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              region.displayPath,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionSelectorDropdown(BuildContext context) {
    final List<FocusRegionType> items =
        _selectableRegionTypes.contains(_selectedRegionType)
            ? _selectableRegionTypes
            : [_selectedRegionType, ..._selectableRegionTypes];

    return SizedBox(
      height: 32,
      child: DropdownButtonFormField<FocusRegionType>(
        value: _selectedRegionType,
        isDense: true,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        style: TextStyle(
          fontSize: 12.5,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        items: items.map((regionType) {
          return DropdownMenuItem<FocusRegionType>(
            value: regionType,
            child: Text(
              'Region: ${regionType.label}',
              style: const TextStyle(fontSize: 12.5),
            ),
          );
        }).toList(),
        onChanged: (FocusRegionType? newValue) {
          if (newValue != null) {
            setState(() => _selectedRegionType = newValue);
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(0);
            }
            _searchFocusNode.requestFocus();
          }
        },
      ),
    );
  }

  Widget _buildShortcutList(BuildContext context) {
    final List<MnemonicShortcutDescriptor> allEntries =
        _KeyboardShortcutCatalog.buildEntriesForRegion(_selectedRegionType);

    final List<MnemonicShortcutDescriptor> filteredEntries =
        _searchQuery.isEmpty
            ? allEntries
            : allEntries.where((entry) {
                final bool matchLabel =
                    entry.actionLabel.toLowerCase().contains(_searchQuery);
                final bool matchKey = entry.keyCaps
                    .any((k) => k.toLowerCase().contains(_searchQuery));
                return matchLabel || matchKey;
              }).toList();

    if (filteredEntries.isEmpty) {
      return Center(
        child: Text(
          'No matching shortcuts found.',
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).hintColor,
          ),
        ),
      );
    }

    // Group entries by MnemonicShortcutGroup while preserving canonical enum order.
    final Map<MnemonicShortcutGroup, List<MnemonicShortcutDescriptor>> grouped =
        {};
    for (final group in MnemonicShortcutGroup.values) {
      final items = filteredEntries.where((e) => e.group == group).toList();
      if (items.isNotEmpty) {
        grouped[group] = items;
      }
    }

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.only(right: 10),
      children: grouped.entries.map((entry) {
        return _buildGroupSection(context, entry.key, entry.value);
      }).toList(),
    );
  }

  Widget _buildGroupSection(
    BuildContext context,
    MnemonicShortcutGroup group,
    List<MnemonicShortcutDescriptor> entries,
  ) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6, left: 2),
            child: Text(
              group.title.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          ...entries.map((entry) => _buildShortcutRow(context, entry)),
        ],
      ),
    );
  }

  Widget _buildShortcutRow(
    BuildContext context,
    MnemonicShortcutDescriptor entry,
  ) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.35),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              entry.actionLabel,
              style: const TextStyle(fontSize: 12.5),
            ),
          ),
          const SizedBox(width: 12),
          Wrap(
            spacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: _buildKeyCapWidgets(context, entry.keyCaps),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildKeyCapWidgets(BuildContext context, List<String> keyCaps) {
    final List<Widget> widgets = [];
    for (int i = 0; i < keyCaps.length; i++) {
      final String cap = keyCaps[i];
      if (cap == '/') {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              '/',
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
        );
        continue;
      }

      if (i > 0 && keyCaps[i - 1] != '/') {
        widgets.add(
          Text(
            '+',
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).hintColor,
            ),
          ),
        );
      }

      widgets.add(_KeyCapBadge(label: cap));
    }
    return widgets;
  }
}

/// Visual representation of a single physical keyboard keycap.
class _KeyCapBadge extends StatelessWidget {
  final String label;

  const _KeyCapBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainerHighest
            : const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.8),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 1),
            blurRadius: 0,
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          fontFamily: 'monospace',
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
