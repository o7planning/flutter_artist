part of '../../core.dart';

class ProzessStageFormViewSwitcher extends StatelessWidget {
  final List<StageFormView> stageFormViews;
  final List<StageFormViewBuilder> stageFormViewBuilders;
  final QuickSuggestionMode quickSuggestionMode;

  const ProzessStageFormViewSwitcher({
    required this.stageFormViews,
    this.stageFormViewBuilders = const [],
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return ProzessStageFormViewSwitcherBuilder(
      ownerClassInstance: this,
      description: 'Prozess Stage Form View Switcher',
      stageFormViews: stageFormViews,
      stageFormViewBuilders: stageFormViewBuilders,
      quickSuggestionMode: quickSuggestionMode,
    );
  }
}
