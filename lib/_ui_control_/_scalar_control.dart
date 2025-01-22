part of '../flutter_artist.dart';

abstract class ScalarControl extends _StatefulWidget {
  final Scalar scalar;
  final StackTrace? currentStackTrace;
  final Widget Function(VoidCallback? onPressed) build;
  final VoidCallback? navigate;
  final ScalarControlType type;

  const ScalarControl({
    super.key,
    required this.currentStackTrace,
    required super.ownerClassInstance,
    super.description,
    required this.scalar,
    required this.build,
    required this.type,
    required this.navigate,
  });

  @override
  State<StatefulWidget> createState() {
    return _ControlButtonState();
  }
}

class _ControlButtonState extends _WidgetState<ScalarControl> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.scalar);
  }

  @override
  WidgetStateType get type => WidgetStateType.customControlBar;

  @override
  Widget buildContent(BuildContext context) {
    ControlPressedAsyncFunction? onPressedAsync = _getOnPressedFunction();
    //
    return widget.build(
      onPressedAsync == null
          ? null
          : () {
              () async {
                bool success = await onPressedAsync!();
                if (success && widget.navigate != null) {
                  widget.navigate!();
                }
              }();
            },
    );
  }

  ControlPressedAsyncFunction? _getOnPressedFunction() {
    switch (widget.type) {
      case ScalarControlType.query:
        bool canQuery = widget.scalar.canQuery();
        return canQuery ? __queryScalar : null;
    }
  }

  Future<bool> __queryScalar() async {
    if (widget.currentStackTrace != null) {
      FlutterArtist.codeFlowLogger.addMethodCall(
        ownerClassInstance: widget.ownerClassInstance,
        currentStackTrace: widget.currentStackTrace!,
        parameters: {},
      );
    }
    //
    return await widget.scalar.query();
  }

  @override
  void addFilterFragmentWidgetState({required bool isShowing}) {
    widget.scalar._addControlWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeFilterFragmentWidgetState() {
    widget.scalar._removeControlWidgetState(
      widgetState: this,
    );
  }
}
