part of '../flutter_artist.dart';

class _FormDataView extends StatefulWidget {
  final FormModel formModel;
  final String locationInfo;
  final Function() onPressedShelf;

  const _FormDataView({
    required this.formModel,
    required this.locationInfo,
    required this.onPressedShelf,
    super.key,
  });

  @override
  State<_FormDataView> createState() => __FormDataViewState();
}

class __FormDataViewState extends State<_FormDataView> {
  static const double iconSize = 18;
  static const double fontSize = 13;

  static const int instantValueTab = 2;
  static const int initial1ValueTab = 1;
  static const int initial0ValueTab = 0;
  late int selectedTab = instantValueTab;

  static const int tabLength = 4;

  late List<ShelfBlockScalarType> listeners;

  late TabbedViewController _controller;

  @override
  void initState() {
    super.initState();
    //
    listeners = FlutterArtist.storage._getListenerShelfBlockScalarTypes(
      eventBlockOrScalar: _BlockOrScalar.block(widget.formModel.block),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFormModelInfo(context),
        const SizedBox(height: 5),
        Expanded(
          child: _buildTabContainer(),
        ),
      ],
    );
  }

  String toJson(Map<String, dynamic> map) {
    String json;
    try {
      json = jsonEncode(
        map,
        toEncodable: (obj) => obj.toString(),
      );
      Map<String, dynamic> m2 = jsonDecode(json);
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      String s = encoder.convert(m2);
      return s;
    } catch (e) {
      return "Error convert to JSON: $e";
    }
  }

  Color _getTabIconColor(TabStatus tabStatus) {
    return tabStatus == TabStatus.selected ? Colors.indigo : Colors.black;
  }

  EdgeInsets _getTabPadding(TabStatus tabStatus) {
    return tabStatus == TabStatus.selected
        ? EdgeInsets.all(5)
        : EdgeInsets.fromLTRB(5, 10, 5, 5);
  }

  Widget _buildTabContainer() {
    FormModelData formModelData = widget.formModel.data;
    Map<String, dynamic> initial0Value = formModelData.initial0FormData;
    Map<String, dynamic> initial1Value = formModelData.initialFormData;
    Map<String, dynamic> instantValue = formModelData.currentFormData;

    String initial0Json = toJson(initial0Value);
    String initial1Json = toJson(initial1Value);
    String instantJson = toJson(instantValue);

    //

    List<TabData> tabs = [];

    tabs.add(
      TabData(
        text: ' Init',
        closable: false,
        leading: (context, status) => Icon(
          _formValueIconData,
          color: _getTabIconColor(status),
          size: iconSize,
        ),
        content: _buildTabContent(
          info:
              "The values returned by ${getClassName(widget.formModel)}.prepareFormData() method.",
          json: initial0Json,
        ),
      ),
    );
    tabs.add(
      TabData(
        text: ' Initial',
        closable: false,
        leading: (context, status) => Icon(
          _formValueIconData,
          color: _getTabIconColor(status),
          size: iconSize,
        ),
        content: _buildTabContent(
          info: "Initial Form values",
          json: initial1Json,
        ),
      ),
    );
    tabs.add(
      TabData(
        text: ' Current',
        closable: false,
        leading: (context, status) => Icon(
          _formValueIconData,
          color: _getTabIconColor(status),
          size: iconSize,
        ),
        content: _buildTabContent(
          info: "The current values of the form (Will be passed to the "
              "${getClassName(widget.formModel)}.callApiCreateItem() "
              "or ${getClassName(widget.formModel)}.callApiUpdateItem() method).",
          json: instantJson,
        ),
      ),
    );

    tabs.add(
      TabData(
        text: ' ',
        closable: false,
        leading: (context, status) => Icon(
          _effectIconData,
          color: _getTabIconColor(status),
          size: iconSize,
        ),
        content: _buildFormEventListenerInfo(),
      ),
    );
    //
    _controller = TabbedViewController(tabs);
    TabbedView tabbedView = TabbedView(controller: _controller);

    TabbedViewThemeData themeData = _getTabbedViewThemeData();

    TabbedViewTheme tabbedViewTheme = TabbedViewTheme(
      data: themeData,
      child: tabbedView,
    );

    //
    return tabbedViewTheme;
  }

  Widget _buildTabTitle({
    required IconData? iconData,
    required Color? iconColor,
    required String title,
  }) {
    return _IconLabelText(
      icon: iconData == null
          ? null
          : Icon(
              iconData,
              size: 18,
              color: iconColor,
            ),
      label: "",
      text: title,
      style: TextStyle(
        color: Theme.of(context).tabBarTheme.labelColor,
      ),
    );
  }

  Widget _buildTabContent({
    required String info,
    required String json,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildInfo(info: info),
          const Divider(height: 10),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 300),
              child: Align(
                alignment: Alignment.topLeft,
                child: TextFormField(
                  initialValue: json,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo({required String info}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: _IconLabelText(
        icon: const Icon(
          _infoIconData,
          size: 16,
        ),
        label: "",
        text: info,
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildFormEventListenerInfo() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildInfo(
                info:
                    "When you successfully add or modify a record on the '${getClassName(widget.formModel.block)}' block, "
                    "the listening blocks will be switched to the 'pending' state, "
                    "they will be lazily queried again when they are visible on the screen.\n"
                    "Here is a list of affected blocks or scalars:"),
            const Divider(height: 10),
            ...listeners.map(
              (listener) => _ShelfBlockScalarTypeWidget(
                shelfBlockScalarType: listener,
                isListener: true,
                isEventSource: false,
                onTap: null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormModelInfo(BuildContext context) {
    return _CustomAppContainer(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BreadCrumb(
            divider: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 3),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 12,
              ),
            ),
            overflow: ScrollableOverflow(
              keepLastDivider: false,
              reverse: false,
              direction: Axis.horizontal,
            ),
            items: [
              BreadCrumbItem(
                content: InkWell(
                  onTap: widget.onPressedShelf,
                  child: _IconLabelText(
                    style: const TextStyle(fontSize: fontSize),
                    icon: Image.asset(
                      "packages/flutter_artist/static-rs/shelf.png",
                      width: 24,
                      height: 20,
                    ),
                    label: '',
                    text: getClassName(widget.formModel.block.shelf),
                  ),
                ),
              ),
              BreadCrumbItem(
                content: _IconLabelText(
                  style: const TextStyle(fontSize: fontSize),
                  icon: const Icon(
                    _blockIconData,
                    size: iconSize,
                  ),
                  label: '',
                  text: getClassName(widget.formModel.block),
                ),
              ),
              BreadCrumbItem(
                content: _IconLabelText(
                  style: const TextStyle(fontSize: fontSize),
                  icon: const Icon(
                    _formModelIconData,
                    size: iconSize,
                  ),
                  label: '',
                  text: getClassName(widget.formModel),
                ),
              ),
            ],
          ),
          const Divider(),
          _IconLabelText(
            style: const TextStyle(fontSize: fontSize),
            icon: const Icon(
              _locationIconData,
              size: iconSize,
              color: Colors.black54,
            ),
            label: "Location: ",
            text: widget.locationInfo,
            suffixIcon: _SimpleSmallIconButton(
              iconData: _copyToClipboardIconData,
              iconSize: 14,
              iconColor: Colors.black54,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: widget.locationInfo));
                var snackBar = const SnackBar(content: Text("Copied!"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ),
        ],
      ),
    );
  }
}
