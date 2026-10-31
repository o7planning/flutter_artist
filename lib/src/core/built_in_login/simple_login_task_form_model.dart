part of '_login.dart';

/// A ready-to-use [TaskFormModel] pre-configured with `userName` and `password` properties.
///
/// Developers can instantiate this class directly or subclass it to override initial
/// default values (e.g., pre-filling a remembered username).
class SimpleLoginTaskFormModel<USER extends ILoggedInUser>
    extends TaskFormModel<EmptyTaskInitData, LoginTaskResultData<USER>,
        EmptyFormInput, CredentialsFormOutput, EmptyAdditionalFormRelatedData> {
  static const String propUserName = "userName";
  static const String propPassword = "password";

  @override
  FormModelStructure defineFormModelStructure() {
    return FormModelStructure(
      simplePropDefs: [
        SimpleFormPropDef<String>(propName: propUserName),
        SimpleFormPropDef<String>(propName: propPassword),
      ],
      multiOptPropDefs: const [],
    );
  }

  @override
  Map<String, dynamic>? extractSimplePropValuesFromInitData({
    required EmptyAdditionalFormRelatedData additionalFormRelatedData,
    required EmptyTaskInitData initData,
  }) {
    return null;
  }

  @override
  OptValueWrap<Object>? extractMultiOptPropValueFromInitData({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData<dynamic, dynamic, dynamic> multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required EmptyAdditionalFormRelatedData additionalFormRelatedData,
    required EmptyTaskInitData initData,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap<Object>?>? extractUpdateValuesForSimpleProps({
    required EmptyFormInput formInput,
  }) {
    return null;
  }

  @override
  OptValueWrap<Object>? extractUpdateValueForMultiOptProp({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData<dynamic, dynamic, dynamic> multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required EmptyFormInput formInput,
  }) {
    return null;
  }

  @override
  Future<EmptyAdditionalFormRelatedData> performLoadAdditionalFormRelatedData({
    required EmptyTaskInitData? initData,
  }) async {
    return EmptyAdditionalFormRelatedData();
  }

  @override
  Future<XData<dynamic, dynamic, dynamic>?> performLoadMultiOptPropXData({
    required String multiOptPropName,
    required SelectionType selectionType,
    required Object? parentMultiOptPropValue,
    required EmptyAdditionalFormRelatedData additionalFormRelatedData,
    required EmptyFormInput? formInput,
    required EmptyTaskInitData? initData,
  }) async {
    return null;
  }

  @override
  CredentialsFormOutput convertToFormOutput({
    required Map<String, dynamic> formMapData,
  }) {
    final String userName =
        (formMapData[propUserName] as String?)?.trim() ?? "";
    final String password = (formMapData[propPassword] as String?) ?? "";

    return CredentialsFormOutput(
      userName: userName,
      password: password,
    );
  }
}
