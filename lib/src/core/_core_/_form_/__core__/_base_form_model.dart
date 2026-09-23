part of '../../core.dart';

abstract class BaseFormModel<
        FORM_INPUT extends FormInput, //
        ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData>
    extends _Core {
  final FormModelConfig config;

  late final FormModelStructure _formModelStructure;

  FormModelStructure get formModelStructure => _formModelStructure;

  FormDataState get dataState => _formModelStructure._formDataState;

  FormErrorInfo? get formErrorInfo => _formModelStructure.formErrorInfo;

  bool get formInitialDataReady => _formModelStructure._formInitialDataReady;

  FormMode get formMode => _formModelStructure.formMode;

  AutovalidateMode _autovalidateMode = AutovalidateMode.onUserInteraction;

  AutovalidateMode get autovalidateMode => _autovalidateMode;

  AutovalidateMode get _autovalidateModeForFormView {
    if (_formModelStructure._formMode == FormMode.none) {
      return AutovalidateMode.disabled;
    }
    return _autovalidateMode;
  }

  late final debug = _FormModelDebugInfo();

  BaseFormModel({
    FormModelConfig config = const FormModelConfig(),
  })  : config = config.copy(),
        _autovalidateMode = config.autovalidateMode {
    __defineFormModelStructure();
  }

  // ***************************************************************************
  // ***************************************************************************

  void __defineFormModelStructure() {
    try {
      _formModelStructure = defineFormModelStructure();
      _formModelStructure.formModel = this;
    }
    // Invalid Form Prop.
    on FormPropInvalidNameError catch (e) {
      String message = "Invalid Form propName '${e.propName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFormModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // Duplicate Form Prop.
    on FormPropDuplicateNameError catch (e) {
      String message = "Duplicate Form propName '${e.propName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFormModelStructure()' method for details.";
      throw _createFatalAppError(message);
    } catch (e, stackTrace) {
      print(stackTrace);
      String message = "Unknown Error $e in ${getClassName(this)}";
      throw _createFatalAppError(message);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// ```dart
  /// @override
  /// FormModelStructure defineFormModelStructure() {
  ///   return FormModelStructure(
  ///     simplePropDefs: [
  ///       SimpleFormPropDef<int>(propName: "id"),
  ///       SimpleFormPropDef<String>(propName: "name"),
  ///       SimpleFormPropDef<String>(propName: "email"),
  ///       SimpleFormPropDef<String>(propName: "address"),
  ///       SimpleFormPropDef<String>(propName: "phone"),
  ///       SimpleFormPropDef<bool>(propName: "active"),
  ///       SimpleFormPropDef<String>(propName: "description"),
  ///       // dynamic or List<XFile>
  ///       SimpleFormPropDef<dynamic>(propName: "xFiles"),
  ///     ],
  ///     multiOptPropDefs: [
  ///       // Multi Option Single Selection Prop.
  ///       MultiOptFormPropDef<SupplierTypeInfo>.singleSelection(
  ///         propName: 'supplierType',
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  ///
  @_AbstractMethodAnnotation()
  FormModelStructure defineFormModelStructure();
}
