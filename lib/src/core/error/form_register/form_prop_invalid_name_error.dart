import '_form_model_register_error.dart';

class FormPropInvalidNameError extends FormModelRegisterError {
  final String propName;

  FormPropInvalidNameError({required this.propName});

  @override
  String toString() {
    return "Invalid Form Prop Name: $propName";
  }
}
