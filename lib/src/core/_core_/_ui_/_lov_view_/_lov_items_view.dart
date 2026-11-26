part of '../../core.dart';

/// Abstract base widget for rendering the selectable item list or table
/// of a [LovModel] (typically hosted inside a [FormBuilderLovField] dialog).
///
/// Subclasses override [buildContent] to present [lovModel.items] and reflect
/// selection state via [lovModel.isSelectedItem] / [lovModel.toggleSelectItem].
abstract class LovView<
    LOV_MODEL extends LovModel<
        Comparable, //
        Identifiable<Comparable>,
        FilterPatch,
        FilterCriteria>> extends StatelessWidget {
  final LOV_MODEL lovModel;
  final LovViewConfig config;

  const LovView({
    required this.lovModel,
    LovViewConfig? config,
    super.key,
  }) : config = config ?? const LovViewConfig();

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return LovViewBuilder(
      ownerClassInstance: this,
      description: '',
      lovModel: lovModel,
      config: config,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
