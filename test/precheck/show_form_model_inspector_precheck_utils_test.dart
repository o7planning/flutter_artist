import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('ShowFormModelInspectorPrecheckUtils Tests', () {
    test('Should return noForm when formModel is null', () {
      final result =
          ShowFormModelInspectorPrecheckUtils.checkBeforeShowFormModelInspector(
        hasForm: false, // Form is missing
        isLoggedIn: true,
        isSystemUser: true,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(ShowFormModelInspectorPrecheck.noForm));
    });

    test('Should return noLoggedInUser when user is not logged in', () {
      final result =
          ShowFormModelInspectorPrecheckUtils.checkBeforeShowFormModelInspector(
        hasForm: true,
        isLoggedIn: false, // User not logged in
        isSystemUser: false,
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
          isLoggedIn: true,
          isSystemUser: false, // Lacks system privileges
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
          isLoggedIn: true,
          isSystemUser: true, // Valid system user
        );

        expect(result.yes, isTrue);
      },
    );
  });
}
