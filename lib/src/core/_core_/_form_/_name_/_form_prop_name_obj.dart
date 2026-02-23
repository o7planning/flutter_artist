part of '../../core.dart';

class FormPropNameObj {
  final String propName;

  FormPropNameObj.parse({required this.propName}) {
    if (!NameUtils.isValidFormPropName(propName)) {
      throw FormPropInvalidNameError(propName: propName);
    }
  }
}
