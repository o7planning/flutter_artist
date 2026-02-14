part of '../core.dart';

abstract class StorageAreaView extends StatelessWidget {
  const StorageAreaView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StorageAreaViewBuilder(
      ownerClassInstance: this,
      description: null,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
