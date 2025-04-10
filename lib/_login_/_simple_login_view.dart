part of '../flutter_artist.dart';

class SimpleLoginView extends StatelessWidget {
  final Zilch zilch;

  const SimpleLoginView({
    super.key,
    required this.zilch,
  });

  @override
  Widget build(BuildContext context) {
    return ZilchFragmentWidgetBuilder(
      zilch: zilch,
      ownerClassInstance: this,
      description: null,
      build: () {
        return Text("OK");
      },
    );
  }
}
