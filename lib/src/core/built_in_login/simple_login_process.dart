part of '_login.dart';

/// A pre-configured base [Prozess] tailored for multi-stage authentication workflows
/// (such as Username/Password -> 2FA/OTP -> Workspace/Tenant Selection).
///
/// It eliminates boilerplate by using [EmptyProzessInitData] and automatically
/// wiring [SessionEstablisher] to extract the [USER] from [SimpleLoginProzessContextData].
abstract class SimpleLoginProzess<
        STAGE_ENUM extends StageEnum,
        USER extends ILoggedInUser,
        CONTEXT_DATA extends SimpleLoginProzessContextData<USER>>
    extends Prozess<STAGE_ENUM, EmptyProzessInitData, CONTEXT_DATA>
    implements SessionEstablisher<USER> {
  SimpleLoginProzess({required super.name});

  @override
  Future<ApiResult<EmptyProzessInitData>> performLoadInitData() async {
    // Standard multi-stage login flows start cold without remote init data.
    return ApiResult.success(data: EmptyProzessInitData());
  }

  @override
  bool isReexecutionAllowed({required EmptyProzessInitData prozessInitData}) {
    // Always allow restarting the login flow from the first stage if needed.
    return true;
  }

  @override
  USER? extractAuthenticatedUser() {
    // Automatically extracts the verified user from the shared context
    // when determineNextStage() returns null (Prozess completion).
    return prozessContextData?.authenticatedUser;
  }
}
