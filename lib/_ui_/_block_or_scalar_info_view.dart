part of '../flutter_artist.dart';

class _BlockOrScalarInfoView extends StatelessWidget {
  final _BlockOrScalar blockOrScalar;

  const _BlockOrScalarInfoView({required this.blockOrScalar});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 0,
      horizontalTitleGap: 5,
      dense: true,
      visualDensity: const VisualDensity(
        horizontal: -3,
        vertical: -3,
      ),
      leading: Icon(
        blockOrScalar.isBlock ? _blockIconData : _scalarIconData,
        size: 18,
      ),
      title: SelectableText.rich(
        style: TextStyle(fontSize: _blockOrScalaInfoFontSize),
        TextSpan(
          children: [
            WidgetSpan(child: SizedBox(width: 3)),
            TextSpan(
              text: blockOrScalar.blockOrScalarClassName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextSpan(
              text: blockOrScalar.blockOrScalaClassParametersDefinition,
              style: const TextStyle(
                color: _classParametersColor,
              ),
            ),
          ],
        ),
      ),
      subtitle: blockOrScalar.description == null
          ? null
          : Text(
              blockOrScalar.description!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
    );
  }
}
