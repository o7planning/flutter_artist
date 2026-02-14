part of '../core.dart';

abstract class ActivityAreaView extends StatelessWidget {
  final Activity activity;

  const ActivityAreaView({
    required this.activity,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return ActivityAreaViewBuilder(
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
