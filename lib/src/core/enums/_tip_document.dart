enum TipDocument {
  config,
  storageStructure,
  flutterArtistAdapter,
  loginLogoutAdapter,
  activity,
  shelf,
  autoStocker,
  polymorphism,
  globalData,
  pageData,
  locale,
  naturalQuery,
  filterCriteria,
  scalarActiveUIComponents,
  blockActiveUIComponents,
  blockQueryType,
  dataState;

  int getPosition() {
    return TipDocument.values.indexOf(this) + 1;
  }

  TipDocument next() {
    int idx = TipDocument.values.indexOf(this);
    idx = (idx + 1) % TipDocument.values.length;
    return TipDocument.values[idx];
  }

  TipDocument previous() {
    int idx = TipDocument.values.indexOf(this);
    idx = (idx - 1) % TipDocument.values.length;
    return TipDocument.values[idx];
  }

  String getTitle() {
    switch (this) {
      case TipDocument.config:
        return "FlutterArtist Config";
      case TipDocument.storageStructure:
        return "FlutterArtist StorageStructure";
      case TipDocument.flutterArtistAdapter:
        return "FlutterArtistAdapter";
      case TipDocument.loginLogoutAdapter:
        return "ILoginLogoutAdapter";
      case TipDocument.activity:
        return "FlutterArtist Activities";
      case TipDocument.shelf:
        return "FlutterArtist Shelves";
      case TipDocument.autoStocker:
        return "FlutterArtist AutoStocker";
      case TipDocument.polymorphism:
        return "FlutterArtist Polymorphism";
      case TipDocument.globalData:
        return "FlutterArtist Global Data";
      case TipDocument.locale:
        return "FlutterArtist Locale and Theme";
      case TipDocument.naturalQuery:
        return "Natural Query";
      case TipDocument.filterCriteria:
        return "Filter Criteria";
      case TipDocument.scalarActiveUIComponents:
        return "Scalar's Active UI Components";
      case TipDocument.blockActiveUIComponents:
        return "Block's Active UI Components";
      case TipDocument.blockQueryType:
        return "Block's QueryType";
      case TipDocument.pageData:
        return "PageData";
      case TipDocument.dataState:
        return "DataState";
    }
  }

  String getTip() {
    switch (this) {
      case TipDocument.config:
        return "FlutterArtist.config()";
      case TipDocument.storageStructure:
        return "FlutterArtist StorageStructure";
      case TipDocument.flutterArtistAdapter:
        return "FlutterArtistAdapter";
      case TipDocument.loginLogoutAdapter:
        return "ILoginLogoutAdapter";
      case TipDocument.activity:
        return "FlutterArtist Activities";
      case TipDocument.shelf:
        return "FlutterArtist Shelves";
      case TipDocument.autoStocker:
        return "FlutterArtist AutoStocker";
      case TipDocument.polymorphism:
        return "FlutterArtist Polymorphism";
      case TipDocument.globalData:
        return "FlutterArtist Global Data";
      case TipDocument.locale:
        return "FlutterArtist Locale and Theme";
      case TipDocument.naturalQuery:
        return "Natural Query";
      case TipDocument.filterCriteria:
        return "Filter Criteria";
      case TipDocument.scalarActiveUIComponents:
        return "Scalar's Active UI Components";
      case TipDocument.blockActiveUIComponents:
        return "Block's Active UI Components";
      case TipDocument.blockQueryType:
        return "Block's QueryType";
      case TipDocument.pageData:
        return "PageData";
      case TipDocument.dataState:
        return "DataState";
    }
  }

  List<String> getDocuments() {
    switch (this) {
      case TipDocument.config:
        return [
          "https://o7planning.org/11111/config1",
          "https://o7planning.org/11112/config2",
        ];
      case TipDocument.storageStructure:
        return [
          "https://o7planning.org/11111/config1",
          "https://o7planning.org/11112/config2",
        ];
      case TipDocument.flutterArtistAdapter:
        return [
          "https://o7planning.org/11111/config1",
          "https://o7planning.org/11112/config2",
        ];
      case TipDocument.loginLogoutAdapter:
        return [
          "https://o7planning.org/11111/config1",
          "https://o7planning.org/11112/config2",
        ];
      case TipDocument.activity:
        return [
          "https://o7planning.org/11111/config1",
          "https://o7planning.org/11112/config2",
        ];
      case TipDocument.shelf:
        return [
          "https://o7planning.org/11111/config1",
          "https://o7planning.org/11112/config2",
        ];
      case TipDocument.autoStocker:
        return [
          "https://o7planning.org/14833/flutterartist-autostocker",
        ];
      case TipDocument.polymorphism:
        return [
          "https://o7planning.org/14835/flutterartist-polymorphisms",
        ];
      case TipDocument.globalData:
        return [
          "https://o7planning.org/14839/flutterartist-global-data",
        ];
      case TipDocument.pageData:
        return [
          "https://o7planning.org/14749/flutterartist-pagedata",
        ];
      case TipDocument.locale:
        return [
          "https://o7planning.org/14837/flutterartist-locales",
        ];
      case TipDocument.naturalQuery:
        return [
          "https://o7planning.org/11111/config1",
          "https://o7planning.org/11112/config2",
        ];
      case TipDocument.filterCriteria:
        return [
          "https://o7planning.org/11111/config1",
          "https://o7planning.org/11112/config2",
        ];
      case TipDocument.scalarActiveUIComponents:
        return [
          "https://o7planning.org/14827/xxx",
        ];
      case TipDocument.blockActiveUIComponents:
        return [
          "https://o7planning.org/14829/xxx",
        ];
      case TipDocument.blockQueryType:
        return [
          "https://o7planning.org/14831/flutterartist-querytype",
        ];
      case TipDocument.dataState:
        return [
          "https://o7planning.org/14749/flutterartist-block-datastate",
        ];
    }
  }
}
