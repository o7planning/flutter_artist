import '../../../enums/_enums.dart';
import '../../core.dart';

part 'filter_execution_calculator.dart';

part 'scalar_execution_calculator.dart';

part 'block_current_item_model_execution_calculator.dart';

part 'block_execution_calculator.dart';

part 'stage_execution_calculator.dart';

part 'block_form_model_execution_calculator.dart';

part 'stage_form_model_execution_calculator.dart';

part 'task_form_model_execution_calculator.dart';

part 'process_execution_calculator.dart';

part 'task_execution_calculator.dart';

enum MissingIntentType {
  dataLoadOrQuery,
  setItemAsCurrent,
  restart,
}
