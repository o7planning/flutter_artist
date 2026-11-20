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
  group('ShowStageInitDataInspectorPrecheckUtils Tests', () {
    const systemUser = _MockLoggedInUser(isSystemUser: true);
    const regularUser = _MockLoggedInUser(isSystemUser: false);

    test('Should return stageUnreached when stageRouteStatus is unreached', () {
      final result = ShowStageInitDataInspectorPrecheckUtils
          .checkBeforeShowInitDataInspector(
        stageRouteStatus: StageRouteStatus.unreached,
        hasInitData: false,
        loggedInUser: null,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ShowStageInitDataInspectorPrecheck.stageUnreached),
      );
    });

    test('Should return stageBypassed when stageRouteStatus is bypassed', () {
      final result = ShowStageInitDataInspectorPrecheckUtils
          .checkBeforeShowInitDataInspector(
        stageRouteStatus: StageRouteStatus.bypassed,
        hasInitData: false,
        loggedInUser: null,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ShowStageInitDataInspectorPrecheck.stageBypassed),
      );
    });

    test(
      'Should return noInitData when stage is active but hasInitData is false',
          () {
        final result = ShowStageInitDataInspectorPrecheckUtils
            .checkBeforeShowInitDataInspector(
          stageRouteStatus: StageRouteStatus.active,
          hasInitData: false,
          loggedInUser: systemUser,
        );

        expect(result.yes, isFalse);
        expect(
          result.errCode,
          equals(ShowStageInitDataInspectorPrecheck.noInitData),
        );
      },
    );

    test('Should return noLoggedInUser when user is not logged in', () {
      final result = ShowStageInitDataInspectorPrecheckUtils
          .checkBeforeShowInitDataInspector(
        stageRouteStatus: StageRouteStatus.active,
        hasInitData: true,
        loggedInUser: null,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ShowStageInitDataInspectorPrecheck.noLoggedInUser),
      );
    });

    test(
      'Should return userIsNotSystemUser when user is not a system user',
          () {
        final result = ShowStageInitDataInspectorPrecheckUtils
            .checkBeforeShowInitDataInspector(
          stageRouteStatus: StageRouteStatus.active,
          hasInitData: true,
          loggedInUser: regularUser,
        );

        expect(result.yes, isFalse);
        expect(
          result.errCode,
          equals(ShowStageInitDataInspectorPrecheck.userIsNotSystemUser),
        );
      },
    );

    test(
      'Should return yes when stage is active, hasInitData is true, and user is system user',
          () {
        final result = ShowStageInitDataInspectorPrecheckUtils
            .checkBeforeShowInitDataInspector(
          stageRouteStatus: StageRouteStatus.active,
          hasInitData: true,
          loggedInUser: systemUser,
        );

        expect(result.yes, isTrue);
      },
    );
  });
}