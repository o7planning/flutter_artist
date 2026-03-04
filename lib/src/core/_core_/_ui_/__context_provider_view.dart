part of '../core.dart';

abstract class _ContextProviderView extends StatefulWidget {
  ///
  /// The owner class instance.
  ///
  final Object ownerClassInstance;

  final String? description;

  const _ContextProviderView({
    required super.key,
    required this.ownerClassInstance,
    required this.description,
  });
}
