part of '../../core.dart';

class ProzessStageViewSwitcher extends StatelessWidget {
  final List<StageView> stageViews;
  final List<StageViewBuilder> stageViewBuilders;
  final QuickSuggestionMode quickSuggestionMode;

  const ProzessStageViewSwitcher({
    required this.stageViews,
    this.stageViewBuilders = const [],
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return ProzessStageViewSwitcherBuilder(
      ownerClassInstance: this,
      description: 'Prozess Stages Switch Container',
      stageViews: stageViews,
      stageViewBuilders: stageViewBuilders,
      quickSuggestionMode: quickSuggestionMode,
    );
  }
}
