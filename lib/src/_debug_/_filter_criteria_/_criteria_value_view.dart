part of '../../../flutter_artist.dart';

class _CriterionValueView extends StatelessWidget {
  final dynamic value;

  const _CriterionValueView({
    required this.value,
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
        value.toString(),
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
