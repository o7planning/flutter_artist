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
  group('ShowDebugInspectorPrecheckUtils Tests', () {
    const systemUser = _MockLoggedInUser(isSystemUser: true);
    const regularUser = _MockLoggedInUser(isSystemUser: false);

    test('Should return noLoggedInUser when user is not logged in', () {
      final result =
          ShowDebugInspectorPrecheckUtils.checkBeforeShowDebugInspector(
        loggedInUser: null,
        requiresRecentModule: true,
        hasRecentModule: false,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ShowDebugInspectorPrecheck.noLoggedInUser),
      );
    });

    test(
      'Should return userIsNotSystemUser when user is not a system user',
      () {
        final result =
            ShowDebugInspectorPrecheckUtils.checkBeforeShowDebugInspector(
          loggedInUser: regularUser,
          requiresRecentModule: true,
          hasRecentModule: false,
        );

        expect(result.yes, isFalse);
        expect(
          result.errCode,
          equals(ShowDebugInspectorPrecheck.userIsNotSystemUser),
        );
      },
    );

    test(
      'Should return noActiveModule when requiresRecentModule is true and hasRecentModule is false',
      () {
        final result =
            ShowDebugInspectorPrecheckUtils.checkBeforeShowDebugInspector(
          loggedInUser: systemUser,
          requiresRecentModule: true,
          hasRecentModule: false,
        );

        expect(result.yes, isFalse);
        expect(
          result.errCode,
          equals(ShowDebugInspectorPrecheck.noActiveModule),
        );
      },
    );

    test(
      'Should return yes when requiresRecentModule is false even if hasRecentModule is false',
      () {
        final result =
            ShowDebugInspectorPrecheckUtils.checkBeforeShowDebugInspector(
          loggedInUser: systemUser,
          requiresRecentModule: false,
          hasRecentModule: false,
        );

        expect(result.yes, isTrue);
      },
    );

    test(
      'Should return yes when requiresRecentModule is true and hasRecentModule is true',
      () {
        final result =
            ShowDebugInspectorPrecheckUtils.checkBeforeShowDebugInspector(
          loggedInUser: systemUser,
          requiresRecentModule: true,
          hasRecentModule: true,
        );

        expect(result.yes, isTrue);
      },
    );
  });
}
