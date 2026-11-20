import '../../core/_core_/_enums_/_enums.dart';
import '../../core/_core_/core.dart';
import '_html_text_list_view.dart';

class ProjectionsView extends HtmlTextListView {
  ProjectionsView({super.key})
      : super(
          htmlTexts: FlutterArtist.debugRegister.debugRegisterProjections,
          tipDocument: TipDocument.projection,
        );
}
