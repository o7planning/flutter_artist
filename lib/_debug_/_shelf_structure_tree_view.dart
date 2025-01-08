part of '../flutter_artist.dart';

class _ShelfStructureTreeView extends StatefulWidget {
  final Shelf shelf;
  final Block? selectedBlock;
  final Function(Block block) onSelectBlock;

  const _ShelfStructureTreeView({
    required super.key,
    required this.shelf,
    required this.selectedBlock,
    required this.onSelectBlock,
  });

  @override
  State<StatefulWidget> createState() {
    return _ShelfStructureTreeViewState();
  }
}

class _ShelfStructureTreeViewState extends State<_ShelfStructureTreeView> {
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
          } else if (data is Block) {
            title = getClassName(data);
            List<ShelfBlockType> listeners = FlutterArtist.storage
                ._getListenerShelfBlockTypes(eventBlock: data);
            List<ShelfBlockType> notifiers = FlutterArtist.storage
                ._getEventShelfBlockTypes(listenerBlock: data);
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
                            ? _listenerColor
                            : isNotifier
                                ? _notifierColor
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
                      _changeSourceIconData,
                      size: 16,
                      color: _notifierColor,
                    ),
                  if (isListener) const SizedBox(width: 5),
                  if (isListener)
                    const Icon(
                      _listenerIconData,
                      size: 16,
                      color: _listenerColor,
                    )
                ],
              ),
              onTap: () {
                setState(() {
                  _currentNode = node;
                  if (node.data is Block) {
                    widget.onSelectBlock(node.data);
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
      _addChildCascade(shelfNode, rootBlock);
    }

    return rootTreeNode;
  }

  void _addChildCascade(TreeNode currentNode, Block block) {
    TreeNode childNode = TreeNode(
      key: "Block-${block.name}",
      data: block,
      // parent: currentNode,
    );
    if (block.name == widget.selectedBlock?.name) {
      _currentNode = childNode;
    }
    currentNode.add(childNode);
    for (Block childBlock in block.childBlocks) {
      _addChildCascade(childNode, childBlock);
    }
  }
}
