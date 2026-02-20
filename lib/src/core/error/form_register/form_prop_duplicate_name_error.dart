import '_form_model_register_error.dart';

class FormPropDuplicateNameError extends FormModelRegisterError {
  final String propName;

  FormPropDuplicateNameError({required this.propName});
}
