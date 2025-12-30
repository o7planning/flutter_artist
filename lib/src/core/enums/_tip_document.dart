enum TipDocument {
  config(enabled: true),
  logViewer(enabled: true),
  codeFlowViewer(enabled: true),
  storageViewer(enabled: true),
  storageStructure(enabled: true),
  coreFeaturesAdapter(enabled: true),
  loginLogoutAdapter(enabled: true),
  activity(enabled: true),
  shelf(enabled: true),
  polymorphism(enabled: true),
  globalData(enabled: true),
  pageData(enabled: true),
  locale(enabled: true),
  naturalQuery(enabled: true),
  filterCriteria(enabled: true),
  blockActiveUIComponents(enabled: true),
  blockQueryType(enabled: true),
  sorting(enabled: true),
  scalarActiveUIComponents(enabled: true),
  dataState(enabled: true),
  eventReactionFreezing(enabled: true),
  debugState(enabled: true),
  canDoAction(enabled: true),
  //
  blockCallApiDeleteItemById(enabled: false),
  blockCallApiQuery(enabled: false),
  blockConvertItemDetailToItem(enabled: false),
  blockCallApiLoadItemDetailById(enabled: false),
  blockExtractParentBlockItemId(enabled: true),
  blockInitFormRelatedData(enabled: false),
  //
  blockSilentActionCallApi(enabled: false),
  //
  blockQuickItemUpdateActionCallApiQuickUpdateItem(enabled: false),
  blockQuickMultiItemsCreationActionCallApiQuickCreateMultiItems(
      enabled: false),
  blockQuickItemCreationActionCallApiQuickCreateItem(enabled: false),
  //
  scalarCallApiQuery(enabled: false),
  //
  formModelCallApiCreateItem(enabled: false),
  formModelCallApiUpdateItem(enabled: false),
  formModelGetUpdatedValuesForSimpleProps(enabled: false),
  formModelSpecifyDefaultValuesForSimpleProps(enabled: false),
  //
  filterModelCallApiLoadMultiOptCriterionXData(enabled: false),
  //
  storageCallApi(enabled: false),
  //
  backgroundActionRun(enabled: false),
  loginActivityCallApiLogin(enabled: false),
  coordinatorCoordinationLogic(enabled: false),
  ;

  final bool enabled;
  static List<TipDocument>? __enabledValues;

  static List<TipDocument> get enabledValues {
    __enabledValues ??= values.where((e) => e.enabled).toList();
    return __enabledValues!;
  }

  const TipDocument({required this.enabled});

  int getPosition() {
    return enabledValues.indexOf(this) + 1;
  }

  TipDocument next() {
    int idx = enabledValues.indexOf(this);
    idx = (idx + 1) % enabledValues.length;
    TipDocument next = enabledValues[idx];
    return next;
  }

  TipDocument previous() {
    int idx = enabledValues.indexOf(this);
    idx = (idx - 1) % enabledValues.length;
    TipDocument previous = enabledValues[idx];
    return previous;
  }

  String getTitle() {
    switch (this) {
      case TipDocument.config:
        return "FlutterArtist Config";
      case TipDocument.storageStructure:
        return "FlutterArtist StorageStructure";
      case TipDocument.coreFeaturesAdapter:
        return "FlutterArtistAdapter";
      case TipDocument.loginLogoutAdapter:
        return "ILoginLogoutAdapter";
      case TipDocument.activity:
        return "FlutterArtist Activities";
      case TipDocument.shelf:
        return "FlutterArtist Shelves";
      case TipDocument.polymorphism:
        return "FlutterArtist Polymorphism";
      case TipDocument.globalData:
        return "FlutterArtist Global Data";
      case TipDocument.locale:
        return "FlutterArtist Locale";
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
      case TipDocument.sorting:
        return "Sorting";
      case TipDocument.eventReactionFreezing:
        return "Queued-Event Freezing";
      case TipDocument.debugState:
        return "Debug State";
      case TipDocument.canDoAction:
        return "Can Do Action";
      case TipDocument.blockExtractParentBlockItemId:
        return "Block.extractParentBlockItemId()";
      case TipDocument.blockCallApiDeleteItemById:
        return "Block.callApiDeleteItemById()";
      case TipDocument.blockCallApiQuery:
        return "Block.callApiQuery()";
      case TipDocument.blockConvertItemDetailToItem:
        return "Block.convertItemDetailToItem()";
      case TipDocument.blockCallApiLoadItemDetailById:
        return "Block.callApiLoadItemDetailById()";
      case TipDocument.blockInitFormRelatedData:
        return "Block.initFormRelatedData()";
      case TipDocument.blockSilentActionCallApi:
        return "BlockSilentAction.callApi()";
      case TipDocument.blockQuickItemUpdateActionCallApiQuickUpdateItem:
        return "BlockQuickItemUpdateAction.callApiQuickUpdateItem()";
      case TipDocument
            .blockQuickMultiItemsCreationActionCallApiQuickCreateMultiItems:
        return "BlockQuickMultiItemsCreationAction.callApiQuickCreateMultiItems()";
      case TipDocument.blockQuickItemCreationActionCallApiQuickCreateItem:
        return "BlockQuickItemCreationAction.callApiQuickCreateItem()";
      case TipDocument.scalarCallApiQuery:
        return "Scalar.callApiQuery()";
      case TipDocument.formModelCallApiCreateItem:
        return "FormModel.callApiCreateItem()";
      case TipDocument.formModelCallApiUpdateItem:
        return "FormModel.callApiUpdateItem()";
      case TipDocument.formModelGetUpdatedValuesForSimpleProps:
        return "FormModel.getUpdatedValuesForSimpleProps()";
      case TipDocument.formModelSpecifyDefaultValuesForSimpleProps:
        return "FormModel.specifyDefaultValuesForSimpleProps()";
      case TipDocument.filterModelCallApiLoadMultiOptCriterionXData:
        return "FilterModel.callApiLoadMultiOptCriterionXData()";
      case TipDocument.storageCallApi:
        return "Storage.callApi()";
      case TipDocument.backgroundActionRun:
        return "BackgroundAction.run()";
      case TipDocument.loginActivityCallApiLogin:
        return "LoginActivity.callApiLogin()";
      case TipDocument.coordinatorCoordinationLogic:
        return "Coordinator.coordinationLogic()";
      case TipDocument.logViewer:
        return "Log Viewer";
      case TipDocument.codeFlowViewer:
        return "Code Flow Viewer";
      case TipDocument.storageViewer:
        return "Storage Viewer";
    }
  }

  String getTip() {
    switch (this) {
      case TipDocument.config:
        return "FlutterArtist.config()";
      case TipDocument.storageStructure:
        return "FlutterArtist StorageStructure";
      case TipDocument.coreFeaturesAdapter:
        return "FlutterArtistAdapter";
      case TipDocument.loginLogoutAdapter:
        return "ILoginLogoutAdapter";
      case TipDocument.activity:
        return "FlutterArtist Activities";
      case TipDocument.shelf:
        return "FlutterArtist Shelves";
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
      case TipDocument.sorting:
        return "Sorting";
      case TipDocument.eventReactionFreezing:
        return "Queued-Event Freezing";
      case TipDocument.debugState:
        return "Debug State";
      case TipDocument.canDoAction:
        return "Can Do Action";
      case TipDocument.blockExtractParentBlockItemId:
        return "Block.extractParentBlockItemId() method.";
      case TipDocument.blockCallApiDeleteItemById:
        return "Block.callApiDeleteItemById()";
      case TipDocument.blockCallApiQuery:
        return "Block.callApiQuery()";
      case TipDocument.blockConvertItemDetailToItem:
        return "Block.convertItemDetailToItem()";
      case TipDocument.blockCallApiLoadItemDetailById:
        return "Block.callApiLoadItemDetailById()";
      case TipDocument.blockInitFormRelatedData:
        return "Block.initFormRelatedData()";
      case TipDocument.blockSilentActionCallApi:
        return "BlockSilentAction.callApi()";
      case TipDocument.blockQuickItemUpdateActionCallApiQuickUpdateItem:
        return "BlockQuickItemUpdateAction.callApiQuickUpdateItem()";
      case TipDocument
            .blockQuickMultiItemsCreationActionCallApiQuickCreateMultiItems:
        return "BlockQuickMultiItemsCreationAction.callApiQuickCreateMultiItems()";
      case TipDocument.blockQuickItemCreationActionCallApiQuickCreateItem:
        return "BlockQuickItemCreationAction.callApiQuickCreateItem()";
      case TipDocument.scalarCallApiQuery:
        return "Scalar.callApiQuery()";
      case TipDocument.formModelCallApiCreateItem:
        return "FormModel.callApiCreateItem()";
      case TipDocument.formModelCallApiUpdateItem:
        return "FormModel.callApiUpdateItem()";
      case TipDocument.formModelGetUpdatedValuesForSimpleProps:
        return "FormModel.getUpdatedValuesForSimpleProps()";
      case TipDocument.formModelSpecifyDefaultValuesForSimpleProps:
        return "FormModel.specifyDefaultValuesForSimpleProps()";
      case TipDocument.filterModelCallApiLoadMultiOptCriterionXData:
        return "FilterModel.callApiLoadMultiOptCriterionXData()";
      case TipDocument.storageCallApi:
        return "Storage.callApi()";
      case TipDocument.backgroundActionRun:
        return "BackgroundAction.run()";
      case TipDocument.loginActivityCallApiLogin:
        return "LoginActivity.callApiLogin()";
      case TipDocument.coordinatorCoordinationLogic:
        return "Coordinator.coordinationLogic()";
      case TipDocument.logViewer:
        return "Log Viewer";
      case TipDocument.codeFlowViewer:
        return "Code Flow Viewer";
      case TipDocument.storageViewer:
        return "Storage Viewer";
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
      case TipDocument.coreFeaturesAdapter:
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
      case TipDocument.sorting:
        return [
          "https://o7planning.org/11111/config1",
          "https://o7planning.org/11112/config2",
        ];
      case TipDocument.eventReactionFreezing:
        return [
          "https://o7planning.org/11111/config1",
          "https://o7planning.org/11112/config2",
        ];
      case TipDocument.debugState:
        return [
          "https://o7planning.org/11111/config1",
          "https://o7planning.org/11112/config2",
        ];
      case TipDocument.canDoAction:
        return [
          "https://o7planning.org/11111/config1",
          "https://o7planning.org/11112/config2",
        ];
      case TipDocument.blockExtractParentBlockItemId:
        return [
          "https://o7planning.org/11111/config1",
          "https://o7planning.org/11112/config2",
        ];
      case TipDocument.logViewer:
        return [
          "https://o7planning.org/14545/flutterartist-log-viewer",
        ];
      case TipDocument.codeFlowViewer:
        return [
          "https://o7planning.org/14833/flutterartist-code-flow-viewer",
        ];
      case TipDocument.storageViewer:
        return [
          "https://o7planning.org/14849/flutterartist-storage-viewer",
        ];
      case TipDocument.blockCallApiDeleteItemById:
        return [];
      case TipDocument.blockCallApiQuery:
        return [];
      case TipDocument.blockConvertItemDetailToItem:
        return [];
      case TipDocument.blockCallApiLoadItemDetailById:
        return [];
      case TipDocument.blockInitFormRelatedData:
        return [];
      case TipDocument.blockSilentActionCallApi:
        return [];
      case TipDocument.blockQuickItemUpdateActionCallApiQuickUpdateItem:
        return [];
      case TipDocument
            .blockQuickMultiItemsCreationActionCallApiQuickCreateMultiItems:
        return [];
      case TipDocument.blockQuickItemCreationActionCallApiQuickCreateItem:
        return [];
      case TipDocument.scalarCallApiQuery:
        return [];
      case TipDocument.formModelCallApiCreateItem:
        return [];
      case TipDocument.formModelCallApiUpdateItem:
        return [];
      case TipDocument.formModelGetUpdatedValuesForSimpleProps:
        return [];
      case TipDocument.formModelSpecifyDefaultValuesForSimpleProps:
        return [];
      case TipDocument.filterModelCallApiLoadMultiOptCriterionXData:
        return [];
      case TipDocument.storageCallApi:
        return [];
      case TipDocument.backgroundActionRun:
        return [];
      case TipDocument.loginActivityCallApiLogin:
        return [];
      case TipDocument.coordinatorCoordinationLogic:
        return [];
    }
  }
}
