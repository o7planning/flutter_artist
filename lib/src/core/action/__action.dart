import 'dart:typed_data';

import 'package:flutter/material.dart' hide Action;
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart'
    as dialogs;
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';
import '../enums/_enums.dart';
import '../typedef/typedefs.dart';
import 'stub/download_helper.dart';
import 'stub/download_helper_stub.dart'
    if (dart.library.html) 'stub/download_helper_web.dart';

part '_action.dart';

part '_background_action.dart';

part 'background_web_download_action.dart';

part 'block_backend_action.dart';

part 'block_quick_item_creation_action.dart';

part 'block_quick_item_replacement_action.dart';

part 'block_quick_item_update_action.dart';

part 'scalar_quick_extra_data_load_action.dart';

part 'storage_backend_action.dart';
