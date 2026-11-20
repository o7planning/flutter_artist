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
  group('ShowProzessContextDataInspectorPrecheckUtils Tests', () {
    const systemUser = _MockLoggedInUser(isSystemUser: true);
    const regularUser = _MockLoggedInUser(isSystemUser: false);

    test('Should return noContextData when hasContextData is false', () {
      final result = ShowProzessContextDataInspectorPrecheckUtils
          .checkBeforeShowContextDataInspector(
        hasContextData: false,
        loggedInUser: null,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ShowProzessContextDataInspectorPrecheck.noContextData),
      );
    });

    test('Should return noLoggedInUser when user is not logged in', () {
      final result = ShowProzessContextDataInspectorPrecheckUtils
          .checkBeforeShowContextDataInspector(
        hasContextData: true,
        loggedInUser: null,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ShowProzessContextDataInspectorPrecheck.noLoggedInUser),
      );
    });

    test(
      'Should return userIsNotSystemUser when user is not a system user',
      () {
        final result = ShowProzessContextDataInspectorPrecheckUtils
            .checkBeforeShowContextDataInspector(
          hasContextData: true,
          loggedInUser: regularUser,
        );

        expect(result.yes, isFalse);
        expect(
          result.errCode,
          equals(ShowProzessContextDataInspectorPrecheck.userIsNotSystemUser),
        );
      },
    );

    test('Should return yes when context data exists and user is system user',
        () {
      final result = ShowProzessContextDataInspectorPrecheckUtils
          .checkBeforeShowContextDataInspector(
        hasContextData: true,
        loggedInUser: systemUser,
      );

      expect(result.yes, isTrue);
    });
  });
}
