part of '../core.dart';

abstract class ActivitySectionView extends StatelessWidget {
  final Activity activity;

  const ActivitySectionView({
    required this.activity,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return ActivitySectionViewBuilder(
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
