part of '../flutter_artist.dart';

class DataFilterFragmentWidgetBuilder extends _StatefulWidget {
  final DataFilter dataFilter;

  final Widget Function() build;

  const DataFilterFragmentWidgetBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.dataFilter,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _DataFilterFragmentWidgetBuilderState();
  }
}

class _DataFilterFragmentWidgetBuilderState
    extends _WidgetState<DataFilterFragmentWidgetBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.dataFilter);
  }

  @override
  WidgetStateType get type => WidgetStateType.filter;

  @override
  void addWidgetStateListener({required bool isShowing}) {
    widget.dataFilter._addWidgetStateListener(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeWidgetStateListener() {
    widget.dataFilter._removeWidgetStateListener(widgetState: this);
  }

  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
  }
}
