part of '../core.dart';

abstract class BlockItemDetailView<
    BLOCK extends Block<
        Object, //
        Identifiable,
        Identifiable,
        FilterInput,
        FilterCriteria,
        FormInput,
        AdditionalFormRelatedData>> extends StatelessWidget {
  final BLOCK block;
  final bool provideFormContext;

  const BlockItemDetailView({
    required this.block,
    this.provideFormContext = false,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockItemDetailViewBuilder(
      ownerClassInstance: this,
      description: '',
      block: block,
      provideFormContext: provideFormContext,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
