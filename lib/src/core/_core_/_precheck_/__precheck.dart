import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../annotation/annotation.dart';
import '../../utils/__utils.dart';

part '_actionable.dart';
part '_check_allow.dart';
part '_parts_/_activity_v1_precheck.dart';
part '_parts_/_background_action_precheck.dart';
part '_parts_/_block_backend_action_precheck.dart';
part '_parts_/_block_clear_current_item_precheck.dart';
part '_parts_/_block_clear_items_precheck.dart';
part '_parts_/_block_form_enable_precheck.dart';
part '_parts_/_block_form_patch_form_fields_precheck.dart';
part '_parts_/_block_form_reset_precheck.dart';
part '_parts_/_block_form_save_precheck.dart';
part '_parts_/_block_item_creation_precheck.dart';
part '_parts_/_block_item_deletion_precheck.dart';
part '_parts_/_block_item_edit_precheck.dart';
part '_parts_/_block_items_deletion_precheck.dart';
part '_parts_/_block_query_precheck.dart';
part '_parts_/_block_quick_item_creation_precheck.dart';
part '_parts_/_block_quick_item_update_precheck.dart';
part '_parts_/_block_set_current_item_precheck.dart';
part '_parts_/_filter_model_data_load_precheck.dart';
part '_parts_/_form_model_data_load_precheck.dart';
part '_parts_/_form_model_patch_form_fields_precheck.dart';
part '_parts_/_form_model_view_changed_precheck.dart';
part '_parts_/_scalar_clear_precheck.dart';
part '_parts_/_scalar_load_extra_data_precheck.dart';
part '_parts_/_scalar_query_precheck.dart';
part '_parts_/_app_backend_action_precheck.dart';
part '_parts_/_shelf_deferred_event_execution_precheck.dart';
part '_parts_/_show_form_info_precheck.dart';
part '_parts_/_stage_form_enable_precheck.dart';
part '_parts_/_stage_load_init_data_precheck.dart';
part '_parts_/_stage_submit_precheck.dart';
part '_parts_/_task_form_enable_precheck.dart';
part '_parts_/_task_load_init_data_precheck.dart';
part '_parts_/_task_submit_precheck.dart';
part '_precheck_code.dart';

@RenameAnnotation()
abstract interface class Precheck {
  PrecheckCode get precheckCode;

  String get message;

  List<String>? get details;
}

abstract interface class FormEnablePrecheck implements Precheck {
  //
}

extension PrecheckExt on Precheck {
  String getInfo() {
    if (details == null || details!.isEmpty) {
      return message;
    }
    return details!.join(", ");
  }
}
