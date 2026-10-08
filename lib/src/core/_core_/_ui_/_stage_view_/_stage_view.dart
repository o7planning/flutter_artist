part of '../../core.dart';

abstract class StageView<
    STAGE extends Stage<
        StageEnum, //
        StageInitData,
        StageResultData,
        ProzessContextData,
        FormInput,
        FormOutput>> extends StatelessWidget {
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

class DefaultStageView<
    STAGE extends Stage<
        StageEnum, //
        StageInitData,
        StageResultData,
        ProzessContextData,
        FormInput,
        FormOutput>> extends StageView<STAGE> {
  final TextStyle? textStyle;
  const DefaultStageView({
    super.key,
    required super.stage,
    this.textStyle,
  });

  @override
  Widget buildContent(BuildContext context) {
    return Text(stage.stageId.welcomeMessage, style: textStyle);
  }
}
