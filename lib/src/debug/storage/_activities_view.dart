import '../../core/_core_/core.dart';
import '../../core/enums/_tip_document.dart';
import '_html_text_list_view.dart';

class ActivitiesView extends HtmlTextListView {
  ActivitiesView({super.key})
      : super(
          htmlTexts: FlutterArtist.debugRegister.debugRegisterActivities,
          tipDocument: TipDocument.activity,
        );
}
