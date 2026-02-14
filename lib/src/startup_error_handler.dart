part of 'core/_core_/core.dart';

class _AppErrorViewer extends StatelessWidget {
  final Object error;

  const _AppErrorViewer({
    super.key,
    required this.error,
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
          child: SelectableText(
            error.toString(),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
