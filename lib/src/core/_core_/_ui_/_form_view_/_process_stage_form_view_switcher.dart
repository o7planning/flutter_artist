part of '../../core.dart';

class ProzessStageFormViewSwitcher extends StatelessWidget {
  final List<StageFormView> stageFormViews;
  final List<StageFormViewBuilder> stageFormViewBuilders;
  final ProzessFormViewConfig config;

  const ProzessStageFormViewSwitcher({
    required this.stageFormViews,
    this.stageFormViewBuilders = const [],
    ProzessFormViewConfig? config,
    super.key,
  }) : config = config ?? const ProzessFormViewConfig();

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return ProzessStageFormViewSwitcherBuilder(
      ownerClassInstance: this,
      description: 'Prozess Stage Form View Switcher',
      stageFormViews: stageFormViews,
      stageFormViewBuilders: stageFormViewBuilders,
      config: config,
    );
  }
}
