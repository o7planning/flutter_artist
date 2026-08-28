part of '../../core.dart';

abstract class StageView<
    STAGE extends Stage<
        Enum, //
        StageData,
        FlowContextData,
        FormInput,
        AdditionalFormRelatedData>> extends StatelessWidget {
  final STAGE stage;
  final QuickSuggestionMode quickSuggestionMode;

  const StageView({
    required this.stage,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return StageViewBuilder(
      ownerClassInstance: this,
      description: '',
      stage: stage,
      quickSuggestionMode: quickSuggestionMode,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
