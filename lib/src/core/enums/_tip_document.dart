enum TipDocument {
  config(enabled: true),
  logViewer(enabled: true),
  codeFlowViewer(enabled: true),
  debugStorageViewer(enabled: true),
  debugShelfStructureViewer(enabled: true),
  debugFilterCriteriaViewer(enabled: true),
  debugFilterModelViewer(enabled: true),
  debugFormModelViewer(enabled: true),
  debugUiComponentsViewer(enabled: true),
  debugMenu(enabled: true),
  storageStructure(enabled: true),
  coreFeaturesAdapter(enabled: true),
  loginLogoutAdapter(enabled: true),
  activity(enabled: true),
  shelf(enabled: true),
  projection(enabled: true),
  routeStack(enabled: true),
  globalData(enabled: true),
  pageData(enabled: true),
  locale(enabled: true),
  naturalQuery(enabled: true),
  filterCriteria(enabled: true),
  blockActiveUiComponents(enabled: true),
  blockQueryType(enabled: true),
  sorting(enabled: true),
  scalarActiveUiComponents(enabled: true),
  dataState(enabled: true),
  eventReactionFreezing(enabled: true),
  debugState(enabled: true),
  canDoAction(enabled: true),
  //
  blockPerformDeleteItemById(enabled: false),
  blockPerformQuery(enabled: false),
  blockConvertItemDetailToItem(enabled: false),
  blockPerformLoadItemDetailById(enabled: false),
  blockExtractParentBlockItemId(enabled: true),
  blockInitFormRelatedData(enabled: false),
  //
  blockBackendActionPerformAction(enabled: false),
  //
  blockQuickItemUpdateActionPerformQuickUpdateItem(enabled: false),
  blockQuickMultiItemCreationActionPerformBulkCreateItems(enabled: false),
  blockQuickItemCreationActionPerformQuickCreateItem(enabled: false),
  //
  scalarPerformQuery(enabled: false),
  //
  formModelPerformCreateItem(enabled: false),
  formModelPerformUpdateItem(enabled: false),
  formModelGetUpdatedValuesForSimpleProps(enabled: false),
  formModelSpecifyDefaultValuesForSimpleProps(enabled: false),
  //
  filterModelPerformLoadMultiOptCriterionXData(enabled: false),
  //
  storagePerformAction(enabled: false),
  //
  backgroundActionRun(enabled: false),
  loginActivityPerformLogin(enabled: false),
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
        return "FlutterArtistLoginLogoutAdapter";
      case TipDocument.activity:
        return "FlutterArtist Activities";
      case TipDocument.shelf:
        return "FlutterArtist Shelves";
      case TipDocument.projection:
        return "FlutterArtist Projection";
      case TipDocument.routeStack:
        return "FlutterArtist Route Stack";
      case TipDocument.globalData:
        return "FlutterArtist Global Data";
      case TipDocument.locale:
        return "FlutterArtist Locale";
      case TipDocument.naturalQuery:
        return "Natural Query";
      case TipDocument.filterCriteria:
        return "Filter Criteria";
      case TipDocument.scalarActiveUiComponents:
        return "Scalar's Active UI Components";
      case TipDocument.blockActiveUiComponents:
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
        return "Deferred-Event Freezing";
      case TipDocument.debugState:
        return "Debug State";
      case TipDocument.canDoAction:
        return "Can Do Action";
      case TipDocument.blockExtractParentBlockItemId:
        return "Block.extractParentBlockItemId()";
      case TipDocument.blockPerformDeleteItemById:
        return "Block.performDeleteItemById()";
      case TipDocument.blockPerformQuery:
        return "Block.performQuery()";
      case TipDocument.blockConvertItemDetailToItem:
        return "Block.convertItemDetailToItem()";
      case TipDocument.blockPerformLoadItemDetailById:
        return "Block.performLoadItemDetailById()";
      case TipDocument.blockInitFormRelatedData:
        return "Block.performLoadFormRelatedData()";
      case TipDocument.blockBackendActionPerformAction:
        return "BlockBackendAction.performBackendOperation()";
      case TipDocument.blockQuickItemUpdateActionPerformQuickUpdateItem:
        return "BlockQuickItemUpdateAction.performQuickUpdateItem()";
      case TipDocument.blockQuickMultiItemCreationActionPerformBulkCreateItems:
        return "BlockQuickMultiItemCreationAction.performQuickCreateMultiItems()";
      case TipDocument.blockQuickItemCreationActionPerformQuickCreateItem:
        return "BlockQuickItemCreationAction.performQuickCreateItem()";
      case TipDocument.scalarPerformQuery:
        return "Scalar.performQuery()";
      case TipDocument.formModelPerformCreateItem:
        return "FormModel.performCreateItem()";
      case TipDocument.formModelPerformUpdateItem:
        return "FormModel.performUpdateItem()";
      case TipDocument.formModelGetUpdatedValuesForSimpleProps:
        return "FormModel.extractUpdateValuesForSimpleProps()";
      case TipDocument.formModelSpecifyDefaultValuesForSimpleProps:
        return "FormModel.specifyDefaultValuesForSimpleProps()";
      case TipDocument.filterModelPerformLoadMultiOptCriterionXData:
        return "FilterModel.performLoadMultiOptTildeCriterionXData()";
      case TipDocument.storagePerformAction:
        return "Storage.performBackendOperation()";
      case TipDocument.backgroundActionRun:
        return "BackgroundAction.run()";
      case TipDocument.loginActivityPerformLogin:
        return "LoginActivity.performLogin()";
      case TipDocument.coordinatorCoordinationLogic:
        return "Coordinator.performSetupOperation()";
      case TipDocument.logViewer:
        return "Log Viewer";
      case TipDocument.codeFlowViewer:
        return "Code Flow Viewer";
      case TipDocument.debugStorageViewer:
        return "Storage Viewer";
      case TipDocument.debugShelfStructureViewer:
        return "Debug Shelf Structure Viewer";
      case TipDocument.debugFilterCriteriaViewer:
        return "FilterCriteria Viewer";
      case TipDocument.debugFilterModelViewer:
        return "Debug Filter Model Viewer";
      case TipDocument.debugFormModelViewer:
        return "Debug Form Model Viewer";
      case TipDocument.debugUiComponentsViewer:
        return "UI Components Viewer";
      case TipDocument.debugMenu:
        return "Debug Menu";
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
        return "FlutterArtistLoginLogoutAdapter";
      case TipDocument.activity:
        return "FlutterArtist Activities";
      case TipDocument.shelf:
        return "FlutterArtist Shelves";
      case TipDocument.projection:
        return "FlutterArtist Projection";
      case TipDocument.routeStack:
        return "FlutterArtist Route Stack";
      case TipDocument.globalData:
        return "FlutterArtist Global Data";
      case TipDocument.locale:
        return "FlutterArtist Locale and Theme";
      case TipDocument.naturalQuery:
        return "Natural Query";
      case TipDocument.filterCriteria:
        return "Filter Criteria";
      case TipDocument.scalarActiveUiComponents:
        return "Scalar's Active UI Components";
      case TipDocument.blockActiveUiComponents:
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
        return "Deferred-Event";
      case TipDocument.debugState:
        return "Debug State";
      case TipDocument.canDoAction:
        return "Can Do Action";
      case TipDocument.blockExtractParentBlockItemId:
        return "Block.extractParentBlockItemId() method.";
      case TipDocument.blockPerformDeleteItemById:
        return "Block.performDeleteItemById()";
      case TipDocument.blockPerformQuery:
        return "Block.performQuery()";
      case TipDocument.blockConvertItemDetailToItem:
        return "Block.convertItemDetailToItem()";
      case TipDocument.blockPerformLoadItemDetailById:
        return "Block.performLoadItemDetailById()";
      case TipDocument.blockInitFormRelatedData:
        return "Block.performLoadFormRelatedData()";
      case TipDocument.blockBackendActionPerformAction:
        return "BlockBackendAction.performBackendOperation()";
      case TipDocument.blockQuickItemUpdateActionPerformQuickUpdateItem:
        return "BlockQuickItemUpdateAction.performQuickUpdateItem()";
      case TipDocument.blockQuickMultiItemCreationActionPerformBulkCreateItems:
        return "BlockQuickMultiItemCreationAction.performQuickCreateMultiItems()";
      case TipDocument.blockQuickItemCreationActionPerformQuickCreateItem:
        return "BlockQuickItemCreationAction.performQuickCreateItem()";
      case TipDocument.scalarPerformQuery:
        return "Scalar.performQuery()";
      case TipDocument.formModelPerformCreateItem:
        return "FormModel.performCreateItem()";
      case TipDocument.formModelPerformUpdateItem:
        return "FormModel.performUpdateItem()";
      case TipDocument.formModelGetUpdatedValuesForSimpleProps:
        return "FormModel.extractUpdateValuesForSimpleProps()";
      case TipDocument.formModelSpecifyDefaultValuesForSimpleProps:
        return "FormModel.specifyDefaultValuesForSimpleProps()";
      case TipDocument.filterModelPerformLoadMultiOptCriterionXData:
        return "FilterModel.performLoadMultiOptTildeCriterionXData()";
      case TipDocument.storagePerformAction:
        return "Storage.performBackendOperation()";
      case TipDocument.backgroundActionRun:
        return "BackgroundAction.run()";
      case TipDocument.loginActivityPerformLogin:
        return "LoginActivity.performLogin()";
      case TipDocument.coordinatorCoordinationLogic:
        return "Coordinator.performSetupOperation()";
      case TipDocument.logViewer:
        return "Log Viewer";
      case TipDocument.codeFlowViewer:
        return "Code Flow Viewer";
      case TipDocument.debugStorageViewer:
        return "Debug Storage Viewer";
      case TipDocument.debugShelfStructureViewer:
        return "Debug Shelf Structure Viewer";
      case TipDocument.debugFilterCriteriaViewer:
        return "Debug FilterCriteria Viewer";
      case TipDocument.debugFilterModelViewer:
        return "Debug Filter Model Viewer";
      case TipDocument.debugFormModelViewer:
        return "Debug Form Model Viewer";
      case TipDocument.debugUiComponentsViewer:
        return "UI Components Viewer";
      case TipDocument.debugMenu:
        return "Debug Menu";
    }
  }

  List<String> getDocuments() {
    switch (this) {
      case TipDocument.config:
        return [
          "http://51.195.44.134:8080/vi/14841/flutterartist-config",
        ];
      case TipDocument.storageStructure:
        return [
          "http://51.195.44.134:8080/vi/11111/config1",
          "http://51.195.44.134:8080/vi/11112/config2",
        ];
      case TipDocument.coreFeaturesAdapter:
        return [
          "http://51.195.44.134:8080/vi/14863/flutterartist-icorefeaturesadapter",
        ];
      case TipDocument.loginLogoutAdapter:
        return [
          "http://51.195.44.134:8080/vi/11111/config1",
          "http://51.195.44.134:8080/vi/11112/config2",
        ];
      case TipDocument.activity:
        return [
          "http://51.195.44.134:8080/vi/11111/config1",
          "http://51.195.44.134:8080/vi/11112/config2",
        ];
      case TipDocument.shelf:
        return [
          "http://51.195.44.134:8080/vi/11111/config1",
          "http://51.195.44.134:8080/vi/11112/config2",
        ];
      case TipDocument.projection:
        return [
          "http://51.195.44.134:8080/vi/14835/flutterartist-projections",
        ];
      case TipDocument.routeStack:
        return [
          "http://51.195.44.134:8080/vi/11111/config1",
          "http://51.195.44.134:8080/vi/11112/config2",
        ];
      case TipDocument.globalData:
        return [
          "http://51.195.44.134:8080/vi/14839/flutterartist-global-data",
        ];
      case TipDocument.pageData:
        return [
          "http://51.195.44.134:8080/vi/14749/flutterartist-pagedata",
        ];
      case TipDocument.locale:
        return [
          "http://51.195.44.134:8080/vi/14837/flutterartist-locales",
        ];
      case TipDocument.naturalQuery:
        return [
          "http://51.195.44.134:8080/vi/11111/config1",
          "http://51.195.44.134:8080/vi/11112/config2",
        ];
      case TipDocument.filterCriteria:
        return [
          "http://51.195.44.134:8080/vi/11111/config1",
          "http://51.195.44.134:8080/vi/11112/config2",
        ];
      case TipDocument.scalarActiveUiComponents:
        return [
          "http://51.195.44.134:8080/vi/14827/xxx",
        ];
      case TipDocument.blockActiveUiComponents:
        return [
          "http://51.195.44.134:8080/vi/14829/xxx",
        ];
      case TipDocument.blockQueryType:
        return [
          "http://51.195.44.134:8080/vi/14831/flutterartist-querytype",
        ];
      case TipDocument.dataState:
        return [
          "http://51.195.44.134:8080/vi/14749/flutterartist-block-datastate",
        ];
      case TipDocument.sorting:
        return [
          "http://51.195.44.134:8080/vi/11111/config1",
          "http://51.195.44.134:8080/vi/11112/config2",
        ];
      case TipDocument.eventReactionFreezing:
        return [
          "http://51.195.44.134:8080/vi/11111/config1",
          "http://51.195.44.134:8080/vi/11112/config2",
        ];
      case TipDocument.debugState:
        return [
          "http://51.195.44.134:8080/vi/11111/config1",
          "http://51.195.44.134:8080/vi/11112/config2",
        ];
      case TipDocument.canDoAction:
        return [
          "http://51.195.44.134:8080/vi/11111/config1",
          "http://51.195.44.134:8080/vi/11112/config2",
        ];
      case TipDocument.blockExtractParentBlockItemId:
        return [
          "http://51.195.44.134:8080/vi/11111/config1",
          "http://51.195.44.134:8080/vi/11112/config2",
        ];
      case TipDocument.logViewer:
        return [
          "http://51.195.44.134:8080/vi/14545/flutterartist-log-viewer",
        ];
      case TipDocument.codeFlowViewer:
        return [
          "http://51.195.44.134:8080/vi/14833/flutterartist-code-flow-viewer",
        ];
      case TipDocument.debugStorageViewer:
        return [
          "http://51.195.44.134:8080/vi/14849/flutterartist-debug-storage-viewer",
        ];
      case TipDocument.debugShelfStructureViewer:
        return [
          "http://51.195.44.134:8080/vi/14865/flutterartist-debug-shelf-structure-viewer",
        ];
      case TipDocument.debugFilterCriteriaViewer:
        return [
          "http://51.195.44.134:8080/vi/14701/flutterartist-filtercriteria",
          "http://51.195.44.134:8080/vi/14851/flutterartist-debug-filter-criteria-viewer",
        ];
      case TipDocument.debugFilterModelViewer:
        return [
          "http://51.195.44.134:8080/vi/14853/flutterartist-debug-filter-model-viewer",
        ];
      case TipDocument.debugFormModelViewer:
        return [
          "http://51.195.44.134:8080/vi/14855/flutterartist-debug-form-model-viewer",
        ];
      case TipDocument.debugUiComponentsViewer:
        return [
          "http://51.195.44.134:8080/vi/14861/flutterartist-debug-ui-components-viewer",
        ];
      case TipDocument.debugMenu:
        return [
          "http://51.195.44.134:8080/vi/14857/flutterartist-debugmenu",
        ];
      case TipDocument.blockPerformDeleteItemById:
        return [];
      case TipDocument.blockPerformQuery:
        return [];
      case TipDocument.blockConvertItemDetailToItem:
        return [];
      case TipDocument.blockPerformLoadItemDetailById:
        return [];
      case TipDocument.blockInitFormRelatedData:
        return [];
      case TipDocument.blockBackendActionPerformAction:
        return [];
      case TipDocument.blockQuickItemUpdateActionPerformQuickUpdateItem:
        return [];
      case TipDocument.blockQuickMultiItemCreationActionPerformBulkCreateItems:
        return [];
      case TipDocument.blockQuickItemCreationActionPerformQuickCreateItem:
        return [];
      case TipDocument.scalarPerformQuery:
        return [];
      case TipDocument.formModelPerformCreateItem:
        return [];
      case TipDocument.formModelPerformUpdateItem:
        return [];
      case TipDocument.formModelGetUpdatedValuesForSimpleProps:
        return [];
      case TipDocument.formModelSpecifyDefaultValuesForSimpleProps:
        return [];
      case TipDocument.filterModelPerformLoadMultiOptCriterionXData:
        return [];
      case TipDocument.storagePerformAction:
        return [];
      case TipDocument.backgroundActionRun:
        return [];
      case TipDocument.loginActivityPerformLogin:
        return [];
      case TipDocument.coordinatorCoordinationLogic:
        return [];
    }
  }
}
