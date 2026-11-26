part of '../_login.dart';

/// A ready-to-use [TaskFormModel] pre-configured with `userName` and `password` properties.
///
/// Developers can instantiate this class directly or subclass it to override initial
/// default values (e.g., pre-filling a remembered username).
abstract class SimpleLoginTaskFormModel<
    USER extends ILoggedInUser, //
    FORM_PATCH extends FormPatch,
    FORM_OUTPUT extends FormOutput // CredentialsFormOutput
    > extends TaskFormModel<
    EmptyTaskInitData, //
    SimpleLoginTaskResultData<USER>,
    FORM_PATCH,
    FORM_OUTPUT,
    EmptyAdditionalFormRelatedData> {
  static const String propUserName = "userName";
  static const String propPassword = "password";

  @override
  FormModelStructure defineFormModelStructure() {
    return FormModelStructure(
      plainPropDefs: [
        PlainFormPropDef<String>(propName: propUserName),
        PlainFormPropDef<String>(propName: propPassword),
      ],
      managedOptPropDefs: const [],
    );
  }

  @override
  Map<String, dynamic>? extractPlainPropValuesFromInitData({
    required EmptyAdditionalFormRelatedData additionalFormRelatedData,
    required EmptyTaskInitData initData,
  }) {
    return null;
  }

  @override
  OptValueWrap<Object>? extractManagedOptPropValueFromInitData({
    required String managedOptPropName,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required XData<dynamic, dynamic, dynamic> managedOptPropXData,
    required Object? parentManagedOptPropValue,
    required EmptyAdditionalFormRelatedData additionalFormRelatedData,
    required EmptyTaskInitData initData,
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
  Future<XData<dynamic, dynamic, dynamic>?> performLoadManagedOptPropXData({
    required String managedOptPropName,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required Object? parentManagedOptPropValue,
    required EmptyAdditionalFormRelatedData additionalFormRelatedData,
    required EmptyTaskInitData? initData,
  }) async {
    return null;
  }
}
