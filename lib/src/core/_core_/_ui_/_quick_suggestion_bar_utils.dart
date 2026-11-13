part of '../core.dart';

class QuickSuggestionBarUtils {
  static _QuickSuggestionButton createBlockErrorButton(
      BuildContext context, Block block) {
    return _QuickSuggestionButton.error(
      tooltip: "Error",
      onPressed: () async {
        await block.showBlockErrorViewerDialog(context);
      },
    );
  }

  static _QuickSuggestionButton createBlockRequeryButton(
      BuildContext context, Block block) {
    return _QuickSuggestionButton.requery(
      tooltip: "Requery",
      onPressed: () async {
        await block.query();
      },
    );
  }

  static _QuickSuggestionButton createScalarErrorButton(
      BuildContext context, Scalar scalar) {
    return _QuickSuggestionButton.error(
      tooltip: "Error",
      onPressed: () async {
        await scalar.showScalarErrorViewerDialog(context);
      },
    );
  }

  static _QuickSuggestionButton createScalarRequeryButton(
      BuildContext context, Scalar scalar) {
    return _QuickSuggestionButton.requery(
      tooltip: "Requery",
      onPressed: () async {
        await scalar.query();
      },
    );
  }

  static _QuickSuggestionButton createFilterModelErrorButton(
      BuildContext context, FilterModel filterModel) {
    return _QuickSuggestionButton.error(
      tooltip: "Error",
      onPressed: () async {
        // await filterModel.showBlockErrorViewerDialog(context);
      },
    );
  }

  static _QuickSuggestionButton createFilterModelRequeryButton(
      BuildContext context, FilterModel filterModel) {
    return _QuickSuggestionButton.requery(
      tooltip: "Requery",
      onPressed: () async {
        await filterModel.query();
      },
    );
  }

  static _QuickSuggestionButton createProzessErrorButton(
      BuildContext context, Prozess prozess) {
    return _QuickSuggestionButton.error(
      tooltip: "Error",
      onPressed: () async {
        prozess.showProzessErrorViewerDialog(context);
      },
    );
  }

  static _QuickSuggestionButton createBlockFormModelErrorButton(
      BuildContext context, BlockFormModel formModel) {
    return _QuickSuggestionButton.error(
      tooltip: "Error",
      onPressed: () async {
        // await formModel.showBlockErrorViewerDialog(context);
      },
    );
  }

  static _QuickSuggestionButton createProzessFormModelErrorButton(
      BuildContext context, Prozess prozess) {
    return _QuickSuggestionButton.error(
      tooltip: "Error",
      onPressed: () async {
        // TODO: Show Form Error.
        prozess.showProzessErrorViewerDialog(context);
      },
    );
  }

  static _QuickSuggestionButton createStageFormModelErrorButton(
      BuildContext context, StageFormModel stageFormModel) {
    return _QuickSuggestionButton.error(
      tooltip: "Error",
      onPressed: () async {
        // TODO: Show Form Error.
        // stageFormModel.showStageErrorViewerDialog(context);
      },
    );
  }

  static _QuickSuggestionButton createStageErrorButton(
      BuildContext context, Stage stage) {
    return _QuickSuggestionButton.error(
      tooltip: "Error",
      onPressed: () async {
        stage.showStageErrorViewerDialog(context);
      },
    );
  }

  static _QuickSuggestionButton createTaskErrorButton(
      BuildContext context, Task task) {
    return _QuickSuggestionButton.error(
      tooltip: "Error",
      onPressed: () async {
        task.showTaskErrorViewerDialog(context);
      },
    );
  }

  static _QuickSuggestionButton createTaskFormModelErrorButton(
      BuildContext context, TaskFormModel taskFormModel) {
    return _QuickSuggestionButton.error(
      tooltip: "Error",
      onPressed: () async {
        // TODO: Show Form Error.
        // taskFormModel.showTaskErrorViewerDialog(context);
      },
    );
  }
}
