import '../../core/_core_/_enums_/_enums.dart';
import '../../core/_core_/core.dart';
import '_html_text_list_view.dart';

class ActivitiesView extends HtmlTextListView {
  ActivitiesView({super.key})
      : super(
    htmlTexts: FlutterArtist.debugRegister.debugRegisterActivities,
    tipDocument: TipDocument.activity,
  );
}
