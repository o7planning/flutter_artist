import '../../core/_core_/core.dart';
import '../../core/enums/_tip_document.dart';
import '_html_text_list_view.dart';

class ShelvesView extends HtmlTextListView {
  ShelvesView({super.key})
      : super(
          htmlTexts: FlutterArtist.debugRegister.debugRegisterShelves,
          tipDocument: TipDocument.shelf,
        );
}
