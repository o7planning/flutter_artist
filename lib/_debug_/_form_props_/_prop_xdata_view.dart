part of '../../flutter_artist.dart';

class _PropXDataView extends StatelessWidget {
  final XData? xData;

  const _PropXDataView({
    required this.xData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Text(
        xData == null ? "null" : xData!.data.toString(),
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
