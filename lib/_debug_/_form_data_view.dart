part of '../flutter_artist.dart';

class _FormDataView extends StatefulWidget {
  final BlockForm blockForm;
  final String locationInfo;
  final Function() onPressedFlu;

  const _FormDataView({
    required this.blockForm,
    required this.locationInfo,
    required this.onPressedFlu,
    super.key,
  });

  @override
  State<_FormDataView> createState() => _FormDataViewState();
}

class _FormDataViewState extends State<_FormDataView> {
  static const double iconSize = 18;
  static const double fontSize = 13;

  static const int instantValueTab = 2;
  static const int initial1ValueTab = 1;
  static const int initial0ValueTab = 0;
  late int selectedTab = instantValueTab;

  static const int tabLength = 4;

  late List<ShelfBlockType> listeners;

  late TabbedViewController _controller;

  @override
  void initState() {
    super.initState();
    //
    listeners = FlutterArtist._changeManager.getChangeListeners(
      sourceBlock: widget.blockForm.block,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildBlockFormInfo(context),
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
    BlockFormData blockFormData = widget.blockForm.data;
    Map<String, dynamic> initial0Value = blockFormData.initial0FormData;
    Map<String, dynamic> initial1Value = blockFormData.initialFormData;
    Map<String, dynamic> instantValue = blockFormData.currentFormData;

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
              "The values returned by ${getClassName(widget.blockForm)}.prepareFormData() method.",
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
              "${getClassName(widget.blockForm)}.callApiCreate() "
              "or ${getClassName(widget.blockForm)}.callApiUpdate() method).",
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
        content: _buildFormChangeListenerInfo(),
      ),
    );
    //
    _controller = TabbedViewController(tabs);
    TabbedView tabbedView = TabbedView(controller: _controller);

    TabbedViewThemeData themeData = TabbedViewThemeData.classic();
    final borderSide = BorderSide(color: Colors.grey, width: 0.7);
    final borderSideTransparent =
        BorderSide(color: Colors.transparent, width: 0.5);
    //
    final boxDecoTabDeselected = BoxDecoration(
      shape: BoxShape.rectangle,
      border: Border(
        left: borderSide,
        right: borderSide,
        top: borderSide,
        bottom: borderSide,
      ),
    );
    final boxDecoTabSelected = BoxDecoration(
      shape: BoxShape.rectangle,
      border: Border(
        left: borderSide,
        right: borderSide,
        top: borderSide,
        bottom: borderSideTransparent,
      ),
    );
    final boxDecoContent = BoxDecoration(
      shape: BoxShape.rectangle,
      border: Border(
        left: borderSide,
        right: borderSide,
        bottom: borderSide,
        top: borderSideTransparent,
      ),
    );
    //
    TabStatusThemeData selectedStatus = TabStatusThemeData()
      ..decoration = boxDecoTabSelected
      ..fontColor = Colors.indigo;
    themeData.tab
      ..hoverButtonColor = Colors.indigo.withAlpha(40)
      ..highlightedStatus.decoration = boxDecoTabSelected
      ..selectedStatus = selectedStatus
      ..decoration = boxDecoTabDeselected;
    //
    themeData.tabsArea
      ..border = Border(bottom: BorderSide(color: Colors.transparent, width: 0))
      ..gapBottomBorder = borderSide
      ..initialGap = 20
      ..middleGap = 5
      ..minimalFinalGap = 2;
    //
    themeData.contentArea.decoration = boxDecoContent;

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

  Widget _buildFormChangeListenerInfo() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildInfo(
              info:
                  "When you successfully add or modify a record on the '${getClassName(widget.blockForm.block)}' block, "
                  "the listening blocks will be switched to the 'pending' state, "
                  "they will be lazily queried again when they are visible on the screen.\n"
                  "Here is a list of affected blocks:"),
          const Divider(height: 10),
          ...listeners.map(
            (listener) => _ShelfBlockTypeWidget(
              shelfBlockType: listener,
              isListener: true,
              isNotifier: false,
              onTap: null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockFormInfo(BuildContext context) {
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
                  onTap: widget.onPressedFlu,
                  child: _IconLabelText(
                    style: const TextStyle(fontSize: fontSize),
                    icon: Image.asset(
                      "packages/flutter_artist/static-rs/flu.png",
                      width: 24,
                      height: 20,
                    ),
                    label: '',
                    text: getClassName(widget.blockForm.block.shelf),
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
                  text: getClassName(widget.blockForm.block),
                ),
              ),
              BreadCrumbItem(
                content: _IconLabelText(
                  style: const TextStyle(fontSize: fontSize),
                  icon: const Icon(
                    _blockFormIconData,
                    size: iconSize,
                  ),
                  label: '',
                  text: getClassName(widget.blockForm),
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
