class HtmlUtils {
  static String removeTags(String html) {
    return html
        .replaceAll("<b>", "")
        .replaceAll("</b>", "")
        .replaceAll("<i>", "")
        .replaceAll("</i>", "")
        .replaceAll("<u>", "")
        .replaceAll("</u>", "");
  }
}
