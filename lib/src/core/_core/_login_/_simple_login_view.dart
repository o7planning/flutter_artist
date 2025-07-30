part of '../../_fa_core.dart';

class SimpleLoginView extends StatelessWidget {
  final Activity activity;

  const SimpleLoginView({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return ActivityFragmentWidgetBuilder(
      activity: activity,
      ownerClassInstance: this,
      description: null,
      build: () {
        return Text("OK");
      },
    );
  }
}
