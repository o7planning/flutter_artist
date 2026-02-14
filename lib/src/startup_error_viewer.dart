part of 'core/_core_/core.dart';

class _StartupErrorViewer extends StatelessWidget {
  final MasterFlowItem masterFlowItem;
  final Object error;

  const _StartupErrorViewer({
    required this.masterFlowItem,
    required this.error,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterArtist Startup Error Viewer',
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Colors.red),
          padding: EdgeInsets.all(10),
          width: double.maxFinite,
          height: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                error.toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  padding: EdgeInsets.all(10),
                  child: MasterFlowItemDetailView(
                    masterFlowItem: masterFlowItem,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
