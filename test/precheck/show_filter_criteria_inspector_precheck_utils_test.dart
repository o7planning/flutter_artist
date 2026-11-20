import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockLoggedInUser implements ILoggedInUser {
  @override
  final bool isSystemUser;

  const _MockLoggedInUser({required this.isSystemUser});

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('ShowFilterCriteriaInspectorPrecheckUtils Tests', () {
    const systemUser = _MockLoggedInUser(isSystemUser: true);
    const regularUser = _MockLoggedInUser(isSystemUser: false);

    test('Should return noFilterModel when hasFilterModel is false', () {
      final result = ShowFilterCriteriaInspectorPrecheckUtils
          .checkBeforeShowFilterCriteriaInspector(
        hasFilterModel: false,
        loggedInUser: null,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ShowFilterCriteriaInspectorPrecheck.noFilterModel),
      );
    });

    test('Should return noLoggedInUser when user is not logged in', () {
      final result = ShowFilterCriteriaInspectorPrecheckUtils
          .checkBeforeShowFilterCriteriaInspector(
        hasFilterModel: true,
        loggedInUser: null,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ShowFilterCriteriaInspectorPrecheck.noLoggedInUser),
      );
    });

    test(
      'Should return userIsNotSystemUser when user is not a system user',
      () {
        final result = ShowFilterCriteriaInspectorPrecheckUtils
            .checkBeforeShowFilterCriteriaInspector(
          hasFilterModel: true,
          loggedInUser: regularUser,
        );

        expect(result.yes, isFalse);
        expect(
          result.errCode,
          equals(ShowFilterCriteriaInspectorPrecheck.userIsNotSystemUser),
        );
      },
    );

    test('Should return yes when filter model exists and user is system user',
        () {
      final result = ShowFilterCriteriaInspectorPrecheckUtils
          .checkBeforeShowFilterCriteriaInspector(
        hasFilterModel: true,
        loggedInUser: systemUser,
      );

      expect(result.yes, isTrue);
    });
  });
}
