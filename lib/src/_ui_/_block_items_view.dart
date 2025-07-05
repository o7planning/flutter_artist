part of '../../flutter_artist.dart';

abstract class BlockItemsView<BLOCK extends Block> extends StatelessWidget {
  final BLOCK block;
  final bool showSuggestionIfError;

  const BlockItemsView({
    required this.block,
    this.showSuggestionIfError = true,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockItemsViewBuilder(
      ownerClassInstance: this,
      description: '',
      block: block,
      showSuggestionIfError: showSuggestionIfError,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
