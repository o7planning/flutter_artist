part of '_login.dart';

/// Strongly-typed form output holding validated login credentials.
class CredentialsFormOutput extends FormOutput {
  final String userName;
  final String password;

  const CredentialsFormOutput({
    required this.userName,
    required this.password,
  });

  @override
  Map<String, dynamic> toDebugMap() {
    return {
      "userName": userName,
      // Masked for security in debug logs and traces
      "password": "***",
    };
  }
}
