part of '../core.dart';

abstract class ActivityV1SectionView extends StatelessWidget {
  final ActivityV1 activity;

  const ActivityV1SectionView({
    required this.activity,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return ActivityV1SectionViewBuilder(
      ownerClassInstance: this,
      description: '',
      activity: activity,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
