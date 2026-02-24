part of '../core.dart';

abstract class StorageSectionView extends StatelessWidget {
  const StorageSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StorageSectionViewBuilder(
      ownerClassInstance: this,
      description: null,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
