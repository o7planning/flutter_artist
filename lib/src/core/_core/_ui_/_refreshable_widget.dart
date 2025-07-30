part of '../../_fa_core.dart';

abstract class _RefreshableWidget extends StatefulWidget {
  ///
  /// The owner class instance.
  ///
  final Object ownerClassInstance;

  final String? description;

  const _RefreshableWidget({
    required super.key,
    required this.ownerClassInstance,
    required this.description,
  });
}
