part of '../../core.dart';

class ProzessStagesViewSwitcher extends StatelessWidget {
  final List<StageView> stageViews;
  final List<StageViewBuilder> stageViewBuilders;

  final ProzessViewConfig config;

  const ProzessStagesViewSwitcher({
    required this.stageViews,
    this.stageViewBuilders = const [],
    ProzessViewConfig? config,
    super.key,
  }) : config = config ?? const ProzessViewConfig();

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return ProzessStagesViewSwitcherBuilder(
      ownerClassInstance: this,
      description: 'Prozess Stages Switch Container',
      stageViews: stageViews,
      stageViewBuilders: stageViewBuilders,
      config: config,
    );
  }
}
