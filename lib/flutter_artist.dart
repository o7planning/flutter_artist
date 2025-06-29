import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:animated_tree_view/tree_view/tree_view.dart';
import 'package:animated_tree_view/tree_view/widgets/expansion_indicator.dart';
import 'package:animated_tree_view/tree_view/widgets/indent.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart'
as dialogs;
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:graphview/GraphView.dart';
import 'package:hive/hive.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:number_pagination/number_pagination.dart' as number_pagination;
import 'package:tabbed_view/tabbed_view.dart';
import 'package:uuid/uuid.dart';
import 'package:visibility_detector/visibility_detector.dart';

part 'src/_action_/_base_action.dart';

part 'src/_action_/_quick_action.dart';

part 'src/_action_/_quick_child_block_items_action.dart';

part 'src/_action_/_quick_create_item_action.dart';

part 'src/_action_/_quick_create_multi_items_action.dart';

part 'src/_action_/_quick_update_item_action.dart';

part 'src/_actionable_/_cre_item_actionable.dart';

part 'src/_adapter_/_flutter_artist_adapter.dart';

part 'src/_adapter_/_global_data_adapter.dart';

part 'src/_adapter_/_logged_in_user_adapter.dart';

part 'src/_adapter_/_notification_adapter.dart';

part 'src/_code_flow_/__code_flow_const.dart';

part 'src/_code_flow_/_code_flow_filter.dart';

part 'src/_code_flow_/_code_flow_func_trace_info_view.dart';

part 'src/_code_flow_/_code_flow_info_error_view.dart';

part 'src/_code_flow_/_code_flow_item.dart';

part 'src/_code_flow_/_code_flow_item_view.dart';

part 'src/_code_flow_/_code_flow_list_item.dart';

part 'src/_code_flow_/_code_flow_logger.dart';

part 'src/_code_flow_/_code_flow_method_args_view.dart';

part 'src/_code_flow_/_code_flow_method_view.dart';

part 'src/_code_flow_/_code_flow_viewer.dart';

part 'src/_code_flow_/_func_call_info.dart';

part 'src/_coordinator_/_coordinator.dart';

part 'src/_core_/_actionable.dart';

part 'src/_core_/_activity.dart';

part 'src/_core_/_block.dart';

part 'src/_core_/_block_data.dart';

part 'src/_core_/_block_or_scalar.dart';

part 'src/_core_/_block_outside_broadcast.dart';

part 'src/_core_/_block_outside_event_reaction.dart';

part 'src/_core_/_current_couple_item.dart';

part 'src/_core_/_custom_confirmation.dart';

part 'src/_core_/_default_filter_model.dart';

part 'src/_core_/_error_listener.dart';

part 'src/_core_/_executor.dart';

part 'src/_core_/_extra_form_input.dart';

part 'src/_core_/_filter_criteria.dart';

part 'src/_core_/_filter_input.dart';

part 'src/_core_/_filter_model.dart';

part 'src/_core_/_form_leave_safely.dart';

part 'src/_core_/_form_model.dart';

part 'src/_core_/_global_data.dart';

part 'src/_core_/_item_sort_criteria.dart';

part 'src/_core_/_logging.dart';

part 'src/_core_/_notification_listener.dart';

part 'src/_core_/_scalar.dart';

part 'src/_core_/_scalar_data.dart';

part 'src/_core_/_scalar_outside_event_reaction.dart';

part 'src/_core_/_shelf.dart';

part 'src/_core_/_shelf_block_scalar_type.dart';

part 'src/_core_/_shelf_structure.dart';

part 'src/_core_/_single_item_block.dart';

part 'src/_core_/_sort_criterion.dart';

part 'src/_core_/_storage.dart';

part 'src/_core_/_suggested_selection.dart';

part 'src/_core_/_typedef.dart';

part 'src/_core_/_x_base.dart';

part 'src/_core_query_/_block_opt.dart';

part 'src/_core_query_/_filter_model_opt.dart';

part 'src/_core_query_/_form_model_opt.dart';

part 'src/_core_/_app_utils.dart';

part 'src/_core_state_/_force_reload_item_calculator.dart';

part 'src/_core_state_/_force_reload_form_calculator.dart';

part 'src/_core_state_/_force_reload_state.dart';

part 'src/_core_query_/_scalar_and_block_list.dart';

part 'src/_core_query_/_scalar_opt.dart';

part 'src/_core_query_/_lazy_objects.dart';

part 'src/_core_query_/_x_block.dart';

part 'src/_core_query_/_x_filter_model.dart';

part 'src/_core_query_/_x_form_model.dart';

part 'src/_core_query_/_x_scalar.dart';

part 'src/_core_query_/_x_shelf.dart';

part 'src/_debug_/_constants.dart';

part 'src/_debug_/_state_/_block_debug_state_view.dart';

part 'src/_debug_/_state_/_block_debug_box.dart';

part 'src/_debug_/_state_/_block_debug_options.dart';

part 'src/_debug_/_state_/_form_debug_options.dart';

part 'src/_debug_/_state_/_form_debug_box.dart';

part 'src/_debug_/_state_/_pagination_debug_box.dart';

part 'src/_debug_/_state_/_pagination_debug_options.dart';

part 'src/_debug_/_/_debug_print.dart';

part 'src/_debug_/_debug_colors_and_styles.dart';

part 'src/_debug_/_debug_utils.dart';

part 'src/_debug_/_error_logger.dart';

part 'src/_debug_/_filter_criteria_/_criteria_value_view.dart';

part 'src/_debug_/_filter_criteria_/_criteria_view.dart';

part 'src/_debug_/_filter_criteria_/_filter_criteria_structure_view.dart';

part 'src/_debug_/_filter_criteria_/_filter_model_debug_view.dart';

part 'src/_debug_/_filter_data_debug_view.dart';

part 'src/_debug_/_form_data_debug_view.dart';

part 'src/_debug_/_form_props_/_form_model_debug_view.dart';

part 'src/_debug_/_form_props_/_form_props_structure_view.dart';

part 'src/_debug_/_graph_item.dart';

part 'src/_debug_/_graph_item_block_or_scalar_box.dart';

part 'src/_debug_/_graph_item_shelf_box.dart';

part 'src/_debug_/_graph_item_simple_shelf_box.dart';

part 'src/_debug_/_shelf_relationship_controller.dart';

part 'src/_debug_/_shelf_relationship_view.dart';

part 'src/_debug_/_shelf_structure_graph_view.dart';

part 'src/_debug_/_shelf_structure_tree_view.dart';

part 'src/_debug_/_shelf_structure_view_config.dart';

part 'src/_debug_/_storage_structure_graph_controller.dart';

part 'src/_debug_/_storage_structure_graph_view.dart';

part 'src/_debug_/_storage_structure_view.dart';

part 'src/_debug_/_widget_/_dynamic_value_view.dart';

part 'src/_debug_/_widget_/_info_view.dart';

part 'src/_debug_/_widget_/_json_view.dart';

part 'src/_debug_/_widget_/_prop_view.dart';

part 'src/_debug_/_widget_/_prop_error_view.dart';

part 'src/_debug_/_widget_/_xdata_view.dart';

part 'src/_debug_filter_/__filter_criteria_debug_view.dart';

part 'src/_debug_filter_/_blk_or_scr_criteria_view.dart';

part 'src/_debug_filter_/_block_criteria_view.dart';

part 'src/_debug_filter_/_blocks_scalars_view.dart';

part 'src/_debug_filter_/_criteria_values_info_view.dart';

part 'src/_debug_filter_/_filter_model_criteria_view.dart';

part 'src/_debug_filter_/_scalar_criteria_view.dart';

part 'src/_dialog_/_code_flow_viewer_dialog.dart';

part 'src/_dialog_/_dev_mode_settings_dialog.dart';

part 'src/_dialog_/_dialog_constants.dart';

part 'src/_dialog_/_dialog_size.dart';

part 'src/_dialog_/_error_log_viewer_dialog.dart';

part 'src/_enum_/_debug_cat.dart';

part 'src/_dialog_/_error_info_viewer.dart';

part 'src/_dialog_/_error_viewer_dialog.dart';

part 'src/_dialog_/_simple_error_viewer_dialog.dart';

part 'src/_dialog_/_form_error_viewer_dialog.dart';

part 'src/_dialog_/_filter_criteria_dialog.dart';

part 'src/_dialog_/_filter_model_info_dialog.dart';

part 'src/_dialog_/_form_data_info_dialog.dart';

part 'src/_dialog_/_location_info_dialog.dart';

part 'src/_ui_/_small_text_button.dart';

part 'src/_dialog_/_storage_dialog.dart';

part 'src/_dialog_/_ui_components_dialog.dart';

part 'src/_enum_/_action_confirmation_type.dart';

part 'src/_enum_/_action_result_state.dart';

part 'src/_enum_/_activity_hidden_behavior.dart';

part 'src/_enum_/_after_quick_action.dart';

part 'src/_enum_/_block_control_action_type.dart';

part 'src/_enum_/_block_hidden_behavior.dart';

part 'src/_enum_/_code_flow_item_type.dart';

part 'src/_enum_/_code_flow_type.dart';

part 'src/_enum_/_current_item_selection_type.dart';

part 'src/_enum_/_data_mode.dart';

part 'src/_enum_/_data_state.dart';

part 'src/_enum_/_filter_activity_type.dart';

part 'src/_enum_/_form_action.dart';

part 'src/_enum_/_form_activity_type.dart';

part 'src/_enum_/_form_debug_item_type.dart';

part 'src/_enum_/_form_mode.dart';

part 'src/_enum_/_form_error_method.dart';

part 'src/_enum_/_item_creation_type.dart';

part 'src/_enum_/_list_behavior.dart';

part 'src/_enum_/_force_type.dart';

part 'src/_enum_/_multi_opt_prop_reload.dart';

part 'src/_enum_/_nli_type.dart';

part 'src/_enum_/_optioned_master_prop_type.dart';

part 'src/_enum_/_post_query_behavior.dart';

part 'src/_enum_/_query_mode.dart';

part 'src/_enum_/_refreshable_widget_type.dart';

part 'src/_enum_/_scalar_control_action_type.dart';

part 'src/_enum_/_scalar_hidden_behavior.dart';

part 'src/_enum_/_shelf_hidden_behavior.dart';

part 'src/_enum_/_show_mode.dart';

part 'src/_enum_/_sorting_direction.dart';

part 'src/_enum_/_sort_rule_side.dart';

part 'src/_enum_/_task_type.dart';

part 'src/_exception_/_fatal_app_exception.dart';

part 'src/_exception_/_duplicate_form_prop_exception.dart';

part 'src/_exception_/_duplicate_filter_criterion_exception.dart';

part 'src/_exception_/_form_internal_error.dart';

part 'src/_core_/_form_error_info.dart';

part 'src/_fa_.dart';

part 'src/_filter_criterion_/_calculated_criterion.dart';

part 'src/_filter_criterion_/_criterion.dart';

part 'src/_filter_criterion_/_filter_criteria_structure.dart';

part 'src/_filter_criterion_/_multi_opt_criterion.dart';

part 'src/_filter_criterion_/_simple_criterion.dart';

part 'src/_form_prop_/_form_props_structure.dart';

part 'src/_form_prop_/_multi_opt_prop.dart';

part 'src/_form_prop_/_prop.dart';

part 'src/_form_prop_/_calculated_prop.dart';

part 'src/_form_prop_/_simple_prop.dart';

part 'src/_form_prop_/_value_wrap.dart';

part 'src/_globals_/_globals_manager.dart';

part 'src/_hive_/_hive_utils.dart';

part 'src/_icon_/_icon_constants.dart';

part 'src/_login_/_login_activity_base.dart';

part 'src/_login_/_simple_login_view.dart';

part 'src/_notification_/_notification.dart';

part 'src/_notification_/_notification_engine.dart';

part 'src/_notification_/_notification_summary.dart';

part 'src/_task_unit_/__task_unit.dart';

part 'src/_task_unit_/__task_unit_queue.dart';

part 'src/_task_unit_/_block_clear_current_task_unit.dart';

part 'src/_task_unit_/_block_delete_item_task_unit.dart';

part 'src/_task_unit_/_block_prepare_form_to_create_item_task_unit.dart';

part 'src/_task_unit_/_block_query_task_unit.dart';

part 'src/_task_unit_/_block_quick_action_task_unit.dart';

part 'src/_task_unit_/_block_quick_child_block_items_task_unit.dart';

part 'src/_task_unit_/_block_quick_create_item_task_unit.dart';

part 'src/_task_unit_/_block_quick_create_multi_items_task_unit.dart';

part 'src/_task_unit_/_block_quick_update_item_task_unit.dart';

part 'src/_task_unit_/_block_select_as_current_task_unit.dart';

part 'src/_task_unit_/_filter_view_change_task_unit.dart';

part 'src/_task_unit_/_form_model_auto_enter_form_fields_task_unit.dart';

part 'src/_task_unit_/_form_model_load_form_task_unit.dart';

part 'src/_task_unit_/_form_model_save_form_task_unit.dart';

part 'src/_task_unit_/_form_view_change_task_unit.dart';

part 'src/_task_unit_/_scalar_query_task_unit.dart';

part 'src/_task_unit_/_scalar_quick_action_task_unit.dart';

part 'src/_task_unit_/_task_result.dart';

part 'src/_ui_/_table_container.dart';

part 'src/_ui_/_activity_fragment_widget_builder.dart';

part 'src/_ui_/_pagination_view.dart';

part 'src/_ui_/_block_control_bar.dart';

part 'src/_ui_/_block_fragment_view_builder.dart';

part 'src/_ui_/_block_fragment_view.dart';

part 'src/_ui_/_block_item_view.dart';

part 'src/_ui_/_block_items_view.dart';

part 'src/_ui_/_block_items_view_builder.dart';

part 'src/_ui_/_block_or_scalar_info_view.dart';

part 'src/_ui_/_control_bar_button.dart';

part 'src/_ui_/_custom_app_container.dart';

part 'src/_ui_/_debug_menu.dart';

part 'src/_ui_/_dev_container.dart';

part 'src/_ui_/_filter_view.dart';

part 'src/_ui_/_filter_view_builder.dart';

part 'src/_ui_/_floating_button.dart';

part 'src/_ui_/_form_view.dart';

part 'src/_ui_/_form_view_builder.dart';

part 'src/_ui_/_labeled_checkbox.dart';

part 'src/_ui_/_labeled_radio.dart';

part 'src/_ui_/_logged_in_user_builder.dart';

part 'src/_ui_/_notification_button_builder.dart';

part 'src/_ui_/_number_pagination_view.dart';

part 'src/_ui_/_refreshable_widget.dart';

part 'src/_ui_/_refreshable_widget_state.dart';

part 'src/_ui_/_scalar_fragment_view.dart';

part 'src/_ui_/_scalar_fragment_view_builder.dart';

part 'src/_ui_/_shelf_block_scalar_type_widget.dart';

part 'src/_ui_/_shelf_info_view.dart';

part 'src/_ui_/_refreshable_neutral_view.dart';

part 'src/_ui_/_refreshable_neutral_view_builder.dart';

part 'src/_ui_/_simple_accordion.dart';

part 'src/_ui_/_simple_accordion_section.dart';

part 'src/_ui_/_sort_options.dart';

part 'src/_ui_/_sort_options_bar.dart';

part 'src/_ui_/_sort_options_dropdown.dart';

part 'src/_ui_/_task_progress_view_builder.dart';

part 'src/_ui_/_x_state.dart';

part 'src/_ui_control_/_block_control.dart';

part 'src/_ui_control_/_block_control_elevated_button.dart';

part 'src/_ui_control_/_block_control_fab.dart';

part 'src/_ui_control_/_block_control_filled_button.dart';

part 'src/_ui_control_/_block_control_inkwell.dart';

part 'src/_ui_control_/_block_control_outlined_button.dart';

part 'src/_ui_control_/_block_control_text_button.dart';

part 'src/_ui_control_/_custom_control_bar.dart';

part 'src/_ui_control_/_custom_control_bar_item.dart';

part 'src/_ui_control_/_scalar_control.dart';

part 'src/_ui_control_/_scalar_control_elevated_button.dart';

part 'src/_ui_control_/_scalar_control_fab.dart';

part 'src/_ui_control_/_scalar_control_filled_button.dart';

part 'src/_ui_control_/_scalar_control_inkwell.dart';

part 'src/_ui_control_/_scalar_control_outlined_button.dart';

part 'src/_ui_control_/_scalar_control_text_button.dart';

part 'src/_utils_/_compare_utils.dart';

part 'src/_utils_/_json_utils.dart';

part 'src/_utils_/_patch_utils.dart';

part 'src/_utils_/_register_error_utils.dart';

part 'src/_utils_/_string_utils.dart';

part 'src/_utils_/_tab_theme_utils.dart';

part 'src/_utils_/_text_size_utils.dart';

part 'src/_utils_/_tooltip_utils.dart';

part 'src/_utils_/_utils.dart';

part 'src/_utils_/_visibility_detector_utils.dart';

part 'src/_xdata_/_x_data.dart';

part 'src/_xdata_/_x_list.dart';

part 'src/_xdata_/_x_tree.dart';

// *****************************************************************************
// *****************************************************************************

class AbstractMethodAnnotation {
  const AbstractMethodAnnotation();
}

class RootMethodAnnotation {
  const RootMethodAnnotation();
}

class ImportantMethodAnnotation {
  const ImportantMethodAnnotation();
}

class MayThrowFormInternalError {
  const MayThrowFormInternalError();
}
