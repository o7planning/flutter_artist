part of '../flutter_artist.dart';

class _FormStructureTreeView extends StatefulWidget {
  final Shelf shelf;
  final FormPropsStructure formPropsStructure;
  final Function(_BlockOrScalar blockOrScalar) onSelectBlockOrScalar;

  const _FormStructureTreeView({
    required super.key,
    required this.shelf,
    required this.formPropsStructure,
    required this.onSelectBlockOrScalar,
  });

  @override
  State<StatefulWidget> createState() {
    return _FormStructureTreeViewState();
  }
}

class _FormStructureTreeViewState extends State<_FormStructureTreeView> {
  TreeViewController<dynamic, TreeNode<dynamic>>? _treeViewController;
  late TreeNode<dynamic> rootTreeNode;
  TreeNode<dynamic>? _currentNode;

  @override
  void initState() {
    super.initState();
    rootTreeNode = _getRootWithChildren();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _CustomAppContainer(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      child: TreeView.simple(
        tree: rootTreeNode,
        showRootNode: false,
        expansionBehavior: ExpansionBehavior.none,
        expansionIndicatorBuilder: (context, node) {
          return ChevronIndicator.upDown(
            tree: node,
            color: Colors.grey[700],
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(0, 8, 20, 8),
            icon: Icons.keyboard_arrow_down_outlined,
          );
        },
        indentation: const Indentation(
          style: IndentStyle.squareJoint,
          thickness: 1,
          width: 10,
        ),
        onTreeReady: (
          TreeViewController<dynamic, TreeNode<dynamic>> controller,
        ) {
          _treeViewController = controller;
          controller.expandAllChildren(rootTreeNode);
        },
        builder: (context, node) {
          dynamic data = node.data;
          String title;
          bool isListener = false;
          bool isNotifier = false;

          if (data is Shelf) {
            title = getClassName(data);
          } else if (data is _BlockOrScalar) {
            if (data.block != null) {
              title = getClassName(data.block!);
            } else {
              title = getClassName(data.scalar!);
            }
            //
            List<ShelfBlockScalarType> listeners = FlutterArtist.storage
                ._getListenerShelfBlockScalarTypes(eventBlockOrScalar: data);

            List<ShelfBlockScalarType> notifiers = FlutterArtist.storage
                ._getEventShelfBlockTypes(listenerBlockOrScalar: data);
            isListener = notifiers.isNotEmpty;
            isNotifier = listeners.isNotEmpty;
          } else {
            title = "ROOT";
          }
          return Material(
            child: ListTile(
              dense: true,
              visualDensity: const VisualDensity(
                horizontal: -3,
                vertical: -3,
              ),
              contentPadding: const EdgeInsets.only(left: 25),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 12,
                        color: isListener
                            ? _listenerTextColor
                            : isNotifier
                                ? _eventSourceTextColor
                                : Colors.black,
                        fontWeight: _currentNode == node
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isNotifier) const SizedBox(width: 5),
                  if (isNotifier)
                    const Icon(
                      _eventSourceIconData,
                      size: 16,
                      color: _eventSourceIconColor,
                    ),
                  if (isListener) const SizedBox(width: 5),
                  if (isListener)
                    const Icon(
                      _listenerIconData,
                      size: 16,
                      color: _listenerIconColor,
                    )
                ],
              ),
              onTap: () {
                setState(() {
                  _currentNode = node;
                  if (node.data is _BlockOrScalar) {
                    widget.onSelectBlockOrScalar(node.data);
                  }
                });
              },
            ),
          );
        },
      ),
    );
  }

  TreeNode _getRootWithChildren() {
    TreeNode shelfNode = TreeNode(
      key: "Shelf-${getClassName(widget.shelf)}",
      data: widget.shelf,
      parent: null,
    );
    rootTreeNode = TreeNode.root()..add(shelfNode);

    List<Block> rootBlocks = widget.shelf.rootBlocks;
    for (Block rootBlock in rootBlocks) {
      _addChildBlockCascade(shelfNode, rootBlock);
    }
    List<Scalar> scalars = widget.shelf.scalars;
    for (Scalar scalar in scalars) {
      _addChildScalar(shelfNode, scalar);
    }

    return rootTreeNode;
  }

  void _addChildBlockCascade(TreeNode currentNode, Block block) {
    // _BlockOrScalar blockOrScalar = _BlockOrScalar.block(block);
    // TreeNode childNode = TreeNode(
    //   key: "Block-${block.name}",
    //   data: blockOrScalar,
    //   // parent: currentNode,
    // );
    // if (blockOrScalar == widget.selectedBlockOrScalar) {
    //   _currentNode = childNode;
    // }
    // currentNode.add(childNode);
    // for (Block childBlock in block.childBlocks) {
    //   _addChildBlockCascade(childNode, childBlock);
    // }
  }

  void _addChildScalar(TreeNode currentNode, Scalar scalar) {
    // _BlockOrScalar blockOrScalar = _BlockOrScalar.scalar(scalar);
    // TreeNode childNode = TreeNode(
    //   key: "Scalar-${scalar.name}",
    //   data: blockOrScalar,
    //   // parent: currentNode,
    // );
    // if (blockOrScalar == widget.selectedBlockOrScalar) {
    //   _currentNode = childNode;
    // }
    // currentNode.add(childNode);
  }
}
