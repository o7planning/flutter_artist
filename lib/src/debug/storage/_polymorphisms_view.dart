import '../../core/_core_/core.dart';
import '../../core/enums/_tip_document.dart';
import '_html_text_list_view.dart';

class PolymorphismsView extends HtmlTextListView {
  PolymorphismsView({super.key})
      : super(
          htmlTexts: FlutterArtist.debugRegister.debugRegisterPolymorphisms,
          tipDocument: TipDocument.polymorphism,
        );
}
