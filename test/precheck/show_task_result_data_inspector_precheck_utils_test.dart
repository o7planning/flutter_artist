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
  group('ShowTaskResultDataInspectorPrecheckUtils Tests', () {
    const systemUser = _MockLoggedInUser(isSystemUser: true);
    const regularUser = _MockLoggedInUser(isSystemUser: false);

    test('Should return noResultData when hasResultData is false', () {
      final result = ShowTaskResultDataInspectorPrecheckUtils
          .checkBeforeShowResultDataInspector(
        hasResultData: false,
        loggedInUser: null,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ShowTaskResultDataInspectorPrecheck.noResultData),
      );
    });

    test('Should return noLoggedInUser when user is not logged in', () {
      final result = ShowTaskResultDataInspectorPrecheckUtils
          .checkBeforeShowResultDataInspector(
        hasResultData: true,
        loggedInUser: null,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ShowTaskResultDataInspectorPrecheck.noLoggedInUser),
      );
    });

    test(
      'Should return userIsNotSystemUser when user is not a system user',
      () {
        final result = ShowTaskResultDataInspectorPrecheckUtils
            .checkBeforeShowResultDataInspector(
          hasResultData: true,
          loggedInUser: regularUser,
        );

        expect(result.yes, isFalse);
        expect(
          result.errCode,
          equals(ShowTaskResultDataInspectorPrecheck.userIsNotSystemUser),
        );
      },
    );

    test('Should return yes when result data exists and user is system user',
        () {
      final result = ShowTaskResultDataInspectorPrecheckUtils
          .checkBeforeShowResultDataInspector(
        hasResultData: true,
        loggedInUser: systemUser,
      );

      expect(result.yes, isTrue);
    });
  });
}
