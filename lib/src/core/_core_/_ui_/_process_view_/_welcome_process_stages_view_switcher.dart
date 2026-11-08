part of '../../core.dart';

class WelcomeProzessStagesViewSwitcher<
    PROZESS extends Prozess<
        StageEnum, //
        ProzessInitData,
        ProzessContextData>> extends StatelessWidget {
  final PROZESS prozess;
  final Widget Function(
          BuildContext context, Stage currentStage, String promptMessage)?
      customContentBuilder;
  final String? description;

  final ProzessViewConfig config;

  const WelcomeProzessStagesViewSwitcher({
    required this.prozess,
    this.customContentBuilder,
    this.description,
    required ProzessViewConfig? config,
    super.key,
  }) : config = config ?? const ProzessViewConfig();

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return WelcomeProzessStagesViewSwitcherBuilder(
      ownerClassInstance: this,
      description: description ?? 'Welcome Prozess Stage View',
      prozess: prozess,
      config: config,
      customContentBuilder: customContentBuilder,
    );
  }
}
