import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:test/test.dart';

class _MockLoggedInUser implements ILoggedInUser {
  @override
  final bool isSystemUser;

  const _MockLoggedInUser({required this.isSystemUser});

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('ShowFormModelInspectorPrecheckUtils Tests', () {
    const systemUser = _MockLoggedInUser(isSystemUser: true);
    const regularUser = _MockLoggedInUser(isSystemUser: false);

    test('Should return noForm when formModel is null', () {
      final result =
          ShowFormModelInspectorPrecheckUtils.checkBeforeShowFormModelInspector(
        hasForm: false, // Form is missing
        loggedInUser: systemUser,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(ShowFormModelInspectorPrecheck.noForm));
    });

    test('Should return noLoggedInUser when user is not logged in', () {
      final result =
          ShowFormModelInspectorPrecheckUtils.checkBeforeShowFormModelInspector(
        hasForm: true,
        loggedInUser: null, // User not logged in
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ShowFormModelInspectorPrecheck.noLoggedInUser),
      );
    });

    test(
      'Should return userIsNotSystemUser when logged-in user is not a system user',
      () {
        final result = ShowFormModelInspectorPrecheckUtils
            .checkBeforeShowFormModelInspector(
          hasForm: true,
          loggedInUser: regularUser, // Lacks system privileges
        );

        expect(result.yes, isFalse);
        expect(
          result.errCode,
          equals(ShowFormModelInspectorPrecheck.userIsNotSystemUser),
        );
      },
    );

    test(
      'Should return yes when form exists and logged-in user has system user privileges',
      () {
        final result = ShowFormModelInspectorPrecheckUtils
            .checkBeforeShowFormModelInspector(
          hasForm: true,
          loggedInUser: systemUser, // Valid system user
        );

        expect(result.yes, isTrue);
      },
    );
  });
}
