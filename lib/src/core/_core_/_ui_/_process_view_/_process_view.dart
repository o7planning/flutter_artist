part of '../../core.dart';

abstract class ProzessView<
    PROZESS extends Prozess<
        StageEnum, //
        ProzessInitData,
        ProzessContextData>> extends StatelessWidget {
  final PROZESS prozess;
  final ProzessViewConfig config;

  const ProzessView({
    required this.prozess,
    required ProzessViewConfig? config,
    super.key,
  }) : config = config ?? const ProzessViewConfig();

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return ProzessViewBuilder(
      ownerClassInstance: this,
      description: '',
      prozess: prozess,
      config: config,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
