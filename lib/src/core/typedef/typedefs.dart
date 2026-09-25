import 'package:flutter/material.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';

typedef CustomConfirmation = Future<bool> Function(BuildContext context);

typedef DefaultConfirmation = Future<bool> Function(BuildContext context);

typedef ShelfCreator<S> = S Function();

typedef ActivityCreator<S> = S Function();

typedef ShowDebugNetworkInspector = Future<void> Function(BuildContext context);

typedef SimpleValConverter<RAW_VALUE> = SimpleVal Function(RAW_VALUE? rawValue);

typedef ControlPressedAsyncFunction = Future<bool> Function();

/// Type alias representing an unconstrained [Block] with wildcard dynamic parameters.
typedef AnyBlock = Block<
    Comparable, //
    Identifiable<Comparable>,
    Identifiable<Comparable>,
    FilterInput,
    FilterCriteria,
    FormInput,
    AdditionalFormRelatedData>;
