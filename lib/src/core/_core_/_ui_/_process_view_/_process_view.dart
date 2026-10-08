part of '../../core.dart';

abstract class ProzessView<
    PROZESS extends Prozess<
        StageEnum, //
        ProzessInitData,
        ProzessContextData>> extends StatelessWidget {
  final PROZESS prozess;
  final QuickSuggestionMode quickSuggestionMode;

  const ProzessView({
    required this.prozess,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return ProzessViewBuilder(
      ownerClassInstance: this,
      description: '',
      prozess: prozess,
      quickSuggestionMode: quickSuggestionMode,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
