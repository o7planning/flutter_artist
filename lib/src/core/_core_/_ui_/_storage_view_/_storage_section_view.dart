part of '../../core.dart';

abstract class StorageSectionView extends StatelessWidget {
  final StorageSectionViewConfig config;

  const StorageSectionView({
    required StorageSectionViewConfig? config,
    super.key,
  }) : config = config ?? const StorageSectionViewConfig();

  @override
  Widget build(BuildContext context) {
    return StorageSectionViewBuilder(
      ownerClassInstance: this,
      description: null,
      config: config,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
