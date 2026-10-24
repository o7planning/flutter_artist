part of '../../core.dart';

class WelcomeProzessStageViewSwitcher<
PROZESS extends Prozess<
    StageEnum, //
    ProzessInitData,
    ProzessContextData>> extends StatelessWidget {
  final PROZESS prozess;
  final QuickSuggestionMode quickSuggestionMode;
  final Widget Function(
      BuildContext context, Stage currentStage, String promptMessage)?
  customContentBuilder;
  final String? description;

  const WelcomeProzessStageViewSwitcher({
    required this.prozess,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.customContentBuilder,
    this.description,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return WelcomeProzessStageViewSwitcherBuilder(
      ownerClassInstance: this,
      description: description ?? 'Welcome Prozess Stage View',
      prozess: prozess,
      quickSuggestionMode: quickSuggestionMode,
      customContentBuilder: customContentBuilder,
    );
  }
}
