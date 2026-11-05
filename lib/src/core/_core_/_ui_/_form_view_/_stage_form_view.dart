part of '../../core.dart';

abstract class StageFormView<
    STAGE_FORM_MODEL extends StageFormModel<
        StageEnum, //
        StageInitData,
        StageResultData,
        ProzessContextData,
        FormPatch,
        FormOutput,
        AdditionalFormRelatedData>> extends StatelessWidget {
  final STAGE_FORM_MODEL formModel;

  const StageFormView({
    required this.formModel,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return StageFormViewBuilder(
      ownerClassInstance: this,
      description: '',
      formModel: formModel,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
