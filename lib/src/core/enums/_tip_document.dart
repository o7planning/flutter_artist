enum TipDocument {
  config,
  storageStructure,
  flutterArtistAdapter,
  loggedInUserAdapter,
  activity,
  shelf,
  autoStocker,
  polymorphism,
  globalData,
  localeAndTheme,
  naturalQuery;

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
      case TipDocument.loggedInUserAdapter:
        return "LoggedInUserAdapter";
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
      case TipDocument.localeAndTheme:
        return "FlutterArtist Locale and Theme";
      case TipDocument.naturalQuery:
        return "Natural Query";
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
      case TipDocument.loggedInUserAdapter:
        return "LoggedInUserAdapter";
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
      case TipDocument.localeAndTheme:
        return "FlutterArtist Locale and Theme";
      case TipDocument.naturalQuery:
        return "Natural Query";
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
      case TipDocument.loggedInUserAdapter:
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
          "https://o7planning.org/11111/config1",
          "https://o7planning.org/11112/config2",
        ];
      case TipDocument.polymorphism:
        return [];
      case TipDocument.globalData:
        return [];
      case TipDocument.localeAndTheme:
        return [];
      case TipDocument.naturalQuery:
        return [
          "https://o7planning.org/11111/config1",
          "https://o7planning.org/11112/config2",
        ];
    }
  }
}
