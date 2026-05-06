enum TipDocument {
  start(enabled: true),
  logViewer(enabled: true),
  codeFlowInspector(enabled: true),
  debugAppInspector(enabled: true),
  debugShelfStructureInspector(enabled: true),
  debugFilterCriteriaInspector(enabled: true),
  debugFilterModelInspector(enabled: true),
  debugFormModelInspector(enabled: true),
  debugUiContextInspector(enabled: true),
  debugMenu(enabled: true),
  appConfiguration(enabled: true),
  coreFeaturesAdapter(enabled: true),
  loginLogoutAdapter(enabled: true),
  activity(enabled: true),
  shelf(enabled: true),
  projection(enabled: true),
  routeStack(enabled: true),
  globalData(enabled: true),
  pageData(enabled: true),
  locale(enabled: true),
  theme(enabled: true),
  naturalQuery(enabled: true),
  filterCriteria(enabled: true),
  blockActiveUiComponents(enabled: true),
  blockQueryType(enabled: true),
  sorting(enabled: true),
  scalarActiveUiComponents(enabled: true),
  dataState(enabled: true),
  deferringEvent(enabled: true),
  debugState(enabled: true),
  canDoAction(enabled: true),
  //
  blockPerformDeleteItemById(enabled: false),
  blockPerformQuery(enabled: false),
  blockConvertItemDetailToItem(enabled: false),
  blockPerformLoadItemDetailById(enabled: false),
  blockResolveParentBlockItemId(enabled: true),
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
  coordinatorPerformSetupOperation(enabled: false),
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
      case TipDocument.start:
        return "FlutterArtist Config";
      case TipDocument.appConfiguration:
        return "FlutterArtist AppConfiguration";
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
      case TipDocument.theme:
        return "FlutterArtist Theme";
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
      case TipDocument.deferringEvent:
        return "Deferred-Event Freezing";
      case TipDocument.debugState:
        return "Debug State";
      case TipDocument.canDoAction:
        return "Can Do Action";
      case TipDocument.blockResolveParentBlockItemId:
        return "Block.resolveParentBlockItemId()";
      case TipDocument.blockPerformDeleteItemById:
        return "Block.performDeleteItemById()";
      case TipDocument.blockPerformQuery:
        return "Block.performQuery()";
      case TipDocument.blockConvertItemDetailToItem:
        return "Block.convertItemDetailToItem()";
      case TipDocument.blockPerformLoadItemDetailById:
        return "Block.performLoadItemDetailById()";
      case TipDocument.blockInitFormRelatedData:
        return "Block.performLoadAdditionalFormRelatedData()";
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
      case TipDocument.coordinatorPerformSetupOperation:
        return "Coordinator.performSetupOperation()";
      case TipDocument.logViewer:
        return "Log Viewer";
      case TipDocument.codeFlowInspector:
        return "Code Flow Inspector";
      case TipDocument.debugAppInspector:
        return "App Inspector";
      case TipDocument.debugShelfStructureInspector:
        return "Debug Shelf Structure Inspector";
      case TipDocument.debugFilterCriteriaInspector:
        return "FilterCriteria Viewer";
      case TipDocument.debugFilterModelInspector:
        return "Debug Filter Model Inspector";
      case TipDocument.debugFormModelInspector:
        return "Debug Form Model Inspector";
      case TipDocument.debugUiContextInspector:
        return "UI Context Inspector";
      case TipDocument.debugMenu:
        return "Debug Menu";
    }
  }

  String getTip() {
    switch (this) {
      case TipDocument.start:
        return "FlutterArtist.start()";
      case TipDocument.appConfiguration:
        return "FlutterArtist AppConfiguration";
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
      case TipDocument.theme:
        return "FlutterArtist Theme";
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
      case TipDocument.deferringEvent:
        return "Deferred-Event";
      case TipDocument.debugState:
        return "Debug State";
      case TipDocument.canDoAction:
        return "Can Do Action";
      case TipDocument.blockResolveParentBlockItemId:
        return "Block.resolveParentBlockItemId() method.";
      case TipDocument.blockPerformDeleteItemById:
        return "Block.performDeleteItemById()";
      case TipDocument.blockPerformQuery:
        return "Block.performQuery()";
      case TipDocument.blockConvertItemDetailToItem:
        return "Block.convertItemDetailToItem()";
      case TipDocument.blockPerformLoadItemDetailById:
        return "Block.performLoadItemDetailById()";
      case TipDocument.blockInitFormRelatedData:
        return "Block.performLoadAdditionalFormRelatedData()";
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
      case TipDocument.coordinatorPerformSetupOperation:
        return "Coordinator.performSetupOperation()";
      case TipDocument.logViewer:
        return "Log Viewer";
      case TipDocument.codeFlowInspector:
        return "Code Flow Inspector";
      case TipDocument.debugAppInspector:
        return "Debug App Inspector";
      case TipDocument.debugShelfStructureInspector:
        return "Debug Shelf Structure Inspector";
      case TipDocument.debugFilterCriteriaInspector:
        return "Debug FilterCriteria Viewer";
      case TipDocument.debugFilterModelInspector:
        return "Debug Filter Model Inspector";
      case TipDocument.debugFormModelInspector:
        return "Debug Form Model Inspector";
      case TipDocument.debugUiContextInspector:
        return "UI Context Inspector";
      case TipDocument.debugMenu:
        return "Debug Menu";
    }
  }

  List<String> getDocuments() {
    switch (this) {
      case TipDocument.start:
        return [
          "14841", // FlutterArtist start
        ];
      case TipDocument.appConfiguration:
        return [
          "14845", // FlutterArtist AppConfiguration
        ];
      case TipDocument.coreFeaturesAdapter:
        return [
          "14863", // FlutterArtist FlutterArtistCoreFeaturesAdapter
        ];
      case TipDocument.loginLogoutAdapter:
        return [
          "14845", // FlutterArtist AppConfiguration
          "14821", // FlutterArtist FlutterArtistLoginLogoutAdapter
        ];
      case TipDocument.activity:
        return [
          "14795", // FlutterArtist Activity ex1
        ];
      case TipDocument.shelf:
        return [
          "14865", // FlutterArtist Debug Shelf Structure Inspector
          "14881", // FlutterArtist Deferring External Shelf Events (ví dụ)
          "14879", // FlutterArtist Internal Shelf Event ex1 (***)
          "14823", // FlutterArtist Scalar External Shelf Event (ví dụ)
        ];
      case TipDocument.projection:
        return [
          "14835", // FlutterArtist Projections (***)
        ];
      case TipDocument.routeStack:
        return [
          "14887", // FlutterArtistRouter
        ];
      case TipDocument.globalData:
        return [
          "14839", // FlutterArtist Global Data (***)
          "14845", // FlutterArtist AppConfiguration
        ];
      case TipDocument.pageData:
        return [
          "14749", // FlutterArtist PageData (***)
        ];
      case TipDocument.locale:
        return [
          "14837", // FlutterArtist Locales (***)
          "14845", // FlutterArtist AppConfiguration
        ];
      case TipDocument.theme:
        return [
          "14889", // Overview of FlutterArtist Theme
          "14891", // Design Tokens Architecture in FlutterArtist Theme
          "14895", // Flutter Artist Theme - Create a custom theme
          "14893", // FlutterArtist Themes FaColorUtils
        ];
      case TipDocument.naturalQuery:
        return [
          "14777", // FlutterArtist Natural Load example 1 (***)
        ];
      case TipDocument.filterCriteria:
        return [
          "14701", // FlutterArtist FilterCriteria (***)
        ];
      case TipDocument.scalarActiveUiComponents:
        return [
          "14827", // FlutterArtist Scalar Active UI Components (***)
        ];
      case TipDocument.blockActiveUiComponents:
        return [
          "14829", // FlutterArtist Block Active UI Components (***)
        ];
      case TipDocument.blockQueryType:
        return [
          "14831", // FlutterArtist Block QueryType (***)
        ];
      case TipDocument.dataState:
        return [
          "14695", // FlutterArtist Block DataState (***)
        ];
      case TipDocument.sorting:
        return [
          "14817", // FlutterArtist Manual Sorting ReorderableGridView (***)
          "14819", // FlutterArtist Manual Sorting ReorderableListView (***)
          "14793", // FlutterArtist Multi Sort ex1 (***)
          "14743", // FlutterArtist Sort DropdownSortPanel Example (***)
        ];
      case TipDocument.deferringEvent:
        return [
          "14881", // FlutterArtist Deferring External Shelf Events (ví dụ)
        ];
      case TipDocument.debugState:
        return [
          "14735", // FlutterArtist DebugBlockStateView (***)
        ];
      case TipDocument.canDoAction:
        return [
          "14755", // FlutterArtist canDoAction (***)
        ];
      case TipDocument.blockResolveParentBlockItemId:
        return [
          "14757", // FlutterArtist Block.resolveParentBlockItemId()
        ];
      case TipDocument.logViewer:
        return [
          "14545", // ￼FlutterArtist Log Viewer
        ];
      case TipDocument.codeFlowInspector:
        return [
          "14833", // FlutterArtist Code Flow Inspector
        ];
      case TipDocument.debugAppInspector:
        return [
          "14849", // FlutterArtist Debug App Inspector
        ];
      case TipDocument.debugShelfStructureInspector:
        return [
          "14865", // FlutterArtist Debug Shelf Structure Inspector
        ];
      case TipDocument.debugFilterCriteriaInspector:
        return [
          "14851", // FlutterArtist Debug Filter Criteria Inspector
          "14853", // FlutterArtist Debug Filter Model Inspector
        ];
      case TipDocument.debugFilterModelInspector:
        return [
          "14853", // FlutterArtist Debug Filter Model Inspector
          "14851", // FlutterArtist Debug Filter Criteria Inspector
        ];
      case TipDocument.debugFormModelInspector:
        return [
          "14855", // FlutterArtist Debug Form Model Inspector
        ];
      case TipDocument.debugUiContextInspector:
        return [
          "14861", // FlutterArtist Debug UI Context Inspector
        ];
      case TipDocument.debugMenu:
        return [
          "14857", // ￼FlutterArtist DebugMenu
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
      case TipDocument.coordinatorPerformSetupOperation:
        return [];
    }
  }
}
