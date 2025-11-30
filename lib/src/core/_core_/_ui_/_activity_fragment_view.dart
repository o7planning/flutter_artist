part of '../core.dart';

abstract class ActivityFragmentView extends StatelessWidget {
  final Activity activity;

  const ActivityFragmentView({
    required this.activity,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return ActivityFragmentViewBuilder(
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
