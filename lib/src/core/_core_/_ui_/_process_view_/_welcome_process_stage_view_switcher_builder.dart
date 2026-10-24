part of '../../core.dart';

class WelcomeProzessStageViewSwitcherBuilder
    extends _BaseProzessStageViewSwitcherBuilder {
  final Prozess prozess;
  final Widget Function(
      BuildContext context, Stage currentStage, String promptMessage)?
  customContentBuilder;

  const WelcomeProzessStageViewSwitcherBuilder({
    super.key,
    required super.ownerClassInstance,
    required this.prozess,
    super.quickSuggestionMode,
    this.customContentBuilder,
    String? description,
  }) : super(description: description ?? 'Welcome Prozess Stage Switcher');

  @override
  State<StatefulWidget> createState() =>
      _WelcomeProzessStageViewSwitcherBuilderState();
}

class _WelcomeProzessStageViewSwitcherBuilderState
    extends _BaseProzessStageViewSwitcherBuilderState<
        WelcomeProzessStageViewSwitcherBuilder> {
  @override
  Prozess getProzess() => widget.prozess;

  @override
  List<Widget> buildStageWidgets(BuildContext context) {
    final List<Widget> stageWidgets = [];

    for (final stage in prozess.orderedStages) {
      stageWidgets.add(
        _DefaultWelcomeStageCard(
          stage: stage,
          customContentBuilder: widget.customContentBuilder,
        ),
      );
    }
    return stageWidgets;
  }
}

/// Internal helper card rendering a default presentation layout for a standard stage.
class _DefaultWelcomeStageCard extends StatelessWidget {
  final Stage stage;
  final Widget Function(
      BuildContext context, Stage currentStage, String promptMessage)?
  customContentBuilder;

  const _DefaultWelcomeStageCard({
    required this.stage,
    this.customContentBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // Extract prompt message dynamically from StageEnum if it implements a message provider pattern.
    final stageEnum = stage.stageId;
    String promptMessage = "Stage: ${stage.name}";

    // Safely check if stageEnum exposes a message property (e.g. via dynamic check or interface matching)
    try {
      final dynamic dynamicEnum = stageEnum;
      if (dynamicEnum.promptMessage != null) {
        promptMessage = dynamicEnum.promptMessage.toString();
      } else if (dynamicEnum.welcomeMessage != null) {
        promptMessage = dynamicEnum.welcomeMessage.toString();
      }
    } catch (_) {
      // Fallback if property does not exist on the given enum implementation.
    }

    if (customContentBuilder != null) {
      return customContentBuilder!(context, stage, promptMessage);
    }

    // Default clean fallback UI layout
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              promptMessage,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Stage Code: ${stageEnum.stageCode} (Order:${stageEnum
                  .stageOrder})",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
