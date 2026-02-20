import '../../core/_core_/core.dart';
import '../../core/enums/_tip_document.dart';
import '_html_text_list_view.dart';

class RouteStackView extends HtmlTextListView {
  RouteStackView({super.key})
      : super(
          htmlTexts: FlutterArtist.navigatorObserver.historyNames,
          tipDocument: TipDocument.routeStack,
        );
}
