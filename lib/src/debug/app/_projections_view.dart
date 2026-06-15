import '../../core/_core_/core.dart';
import '../../core/enums/_tip_document.dart';
import '_html_text_list_view.dart';

class ProjectionsView extends HtmlTextListView {
  ProjectionsView({super.key})
      : super(
          htmlTexts: FlutterArtist.debugRegister.debugRegisterProjections,
          tipDocument: TipDocument.projection,
        );
}
