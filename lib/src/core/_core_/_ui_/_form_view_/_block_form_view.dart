part of '../../core.dart';

abstract class BlockFormView<
    BLOCK_FORM_MODEL extends BlockFormModel<
        Comparable, //
        Identifiable<Comparable>,
        CreationPreset,
        FormPatch,
        FormOutput,
        AdditionalFormRelatedData>> extends StatelessWidget {
  final BLOCK_FORM_MODEL formModel;
  final BlockFormViewConfig config;

  const BlockFormView({
    required this.formModel,
    required BlockFormViewConfig? config,
    super.key,
  }) : config = config ?? const BlockFormViewConfig();

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockFormViewBuilder(
      ownerClassInstance: this,
      description: '',
      formModel: formModel,
      config: config,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
