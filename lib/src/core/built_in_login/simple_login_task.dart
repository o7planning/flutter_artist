part of '_login.dart';

/// A pre-configured [Task] designed to streamline standard authentication workflows
/// (such as Username/Password login or OAuth2/SSO token handshakes).
///
/// This class implements [SessionEstablisher] out of the box, automatically binding
/// the returned [USER] from [performLogin] into the framework's global session manager
/// while wrapping the result inside [LoginTaskResultData] for state inspection.
///
/// ### Usage Scenarios:
/// 1. **Form-based Login (Username/Password)**: Provide a [SimpleLoginTaskFormModel] (or custom [TaskFormModel])
///    to validate and extract user credentials before [performLogin] is called.
/// 2. **Passwordless / OAuth Login (e.g., Microsoft, Google)**: Pass `formModel: null` and
///    implement the OAuth trigger directly inside [performLogin].
abstract class SimpleLoginTask<
    USER extends ILoggedInUser, //
    FORM_INPUT extends FormInput,
    FORM_OUTPUT extends FormOutput> extends Task<
    EmptyTaskInitData, //
    LoginTaskResultData<USER>,
    FORM_INPUT,
    FORM_OUTPUT> implements SessionEstablisher<USER> {
  SimpleLoginTask({
    required super.name,
    super.description,
    super.config = const TaskConfig(),
    required super.formModel,
  });

  // ===========================================================================
  // DEVELOPER CONTRACTS
  // ===========================================================================

  /// Executes the authentication handshake with the remote server or OAuth provider.
  ///
  /// The [formData] parameter contains the validated credentials extracted from the
  /// [formModel], or `null` if this task operates without a form (e.g., SSO/OAuth).
  @AbstractMethodAnnotation()
  Future<ApiResult<USER>> performLogin({
    required FORM_OUTPUT? formData,
  });

  // ===========================================================================
  // PRE-CONFIGURED TASK LIFECYCLE
  // ===========================================================================

  @override
  Future<ApiResult<EmptyTaskInitData>> performLoadInitData() async {
    // Simple login workflows do not require remote baseline initialization data.
    return ApiResult.success(data: EmptyTaskInitData());
  }

  @override
  Future<ApiResult<LoginTaskResultData<USER>>> performSubmit({
    required EmptyTaskInitData initData,
    required FORM_OUTPUT? formData,
  }) async {
    // 1. Delegate to the developer's authentication implementation.
    final ApiResult<USER> loginResult = await performLogin(formData: formData);

    // 2. Propagate API errors directly if the authentication failed.
    if (loginResult.error != null) {
      return ApiResult.fromError(loginResult.error!);
    }

    final USER? authenticatedUser = loginResult.data;
    if (authenticatedUser == null) {
      throw AppError(
        errorMessage:
            "${getClassNameWithoutGenerics(this)}.performLogin() returned null user data.",
      );
    }

    // 3. Wrap the clean USER domain object into LoginTaskResult for Task state & debuggers.
    return ApiResult.success(
      data: LoginTaskResultData<USER>(user: authenticatedUser),
    );
  }

  @override
  USER? extractAuthenticatedUser() {
    // Automatically unwraps the authenticated user from LoginTaskResult
    // to satisfy the SessionEstablisher contract.
    return submitResultData?.user;
  }

  @override
  bool isReexecutionAllowed({required EmptyTaskInitData initData}) => true;

  @override
  bool isMultipleSubmissionsAllowed({required EmptyTaskInitData initData}) =>
      true;
}
