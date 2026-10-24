part of '../../core.dart';

class WelcomeStageView<
    STAGE extends Stage<
        StageEnum, //
        StageInitData,
        StageResultData,
        ProzessContextData,
        FormInput,
        FormOutput>> extends StageView<STAGE> {
  final TextStyle? textStyle;

  const WelcomeStageView({
    super.key,
    required super.stage,
    this.textStyle,
  });

  @override
  Widget buildContent(BuildContext context) {
    return Text(stage.stageId.welcomeMessage, style: textStyle);
  }
}
