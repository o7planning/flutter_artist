part of '../flutter_artist.dart';

class _GalleryStructureView extends StatefulWidget {
  final Function(Frame frame) onSelectFrameToShowGraph;

  const _GalleryStructureView({
    super.key,
    required this.onSelectFrameToShowGraph,
  });

  @override
  State<StatefulWidget> createState() {
    return _GalleryStructureViewState();
  }
}

class _GalleryStructureViewState extends State<_GalleryStructureView> {
  final _GalleryStructureGraphController globalFluStructureGraphController =
      _GalleryStructureGraphController();

  final _FrameRelationshipController frameRelationshipController =
      _FrameRelationshipController();

  Frame? _selectedFrame;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 130,
          child: _GalleryStructureGraphView(
            controller: globalFluStructureGraphController,
            onSelectFrameToShowGraph: widget.onSelectFrameToShowGraph,
            onSelectFrameToShowTreeView: (Frame frame) {
              setState(() {
                _selectedFrame = frame;
              });
            },
          ),
        ),
        const Divider(),
        Expanded(
          child: _FrameRelationshipView(
            frameRelationshipController: frameRelationshipController,
            frame: _selectedFrame,
            onSelectFrameBlockType: (FrameBlockType frameBlockType) {
              Type frameType = frameBlockType.frameType;
              Frame? frame = FlutterArtist._findFrame(frameType);
              if (frame != null) {
                globalFluStructureGraphController.setSelectedFrame(frame);
              }
            },
          ),
        ),
      ],
    );
  }
}
