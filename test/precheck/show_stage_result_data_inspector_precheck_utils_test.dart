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
  group('ShowStageResultDataInspectorPrecheckUtils Tests', () {
    const systemUser = _MockLoggedInUser(isSystemUser: true);
    const regularUser = _MockLoggedInUser(isSystemUser: false);

    test('Should return stageUnreached when stageRouteStatus is unreached', () {
      final result = ShowStageResultDataInspectorPrecheckUtils
          .checkBeforeShowResultDataInspector(
        stageRouteStatus: StageRouteStatus.unreached,
        hasResultData: false,
        loggedInUser: null,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ShowStageResultDataInspectorPrecheck.stageUnreached),
      );
    });

    test('Should return stageBypassed when stageRouteStatus is bypassed', () {
      final result = ShowStageResultDataInspectorPrecheckUtils
          .checkBeforeShowResultDataInspector(
        stageRouteStatus: StageRouteStatus.bypassed,
        hasResultData: false,
        loggedInUser: null,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ShowStageResultDataInspectorPrecheck.stageBypassed),
      );
    });

    test(
      'Should return noResultData when stage is active but hasResultData is false',
      () {
        final result = ShowStageResultDataInspectorPrecheckUtils
            .checkBeforeShowResultDataInspector(
          stageRouteStatus: StageRouteStatus.active,
          hasResultData: false,
          loggedInUser: systemUser,
        );

        expect(result.yes, isFalse);
        expect(
          result.errCode,
          equals(ShowStageResultDataInspectorPrecheck.noResultData),
        );
      },
    );

    test('Should return noLoggedInUser when user is not logged in', () {
      final result = ShowStageResultDataInspectorPrecheckUtils
          .checkBeforeShowResultDataInspector(
        stageRouteStatus: StageRouteStatus.active,
        hasResultData: true,
        loggedInUser: null,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ShowStageResultDataInspectorPrecheck.noLoggedInUser),
      );
    });

    test(
      'Should return userIsNotSystemUser when user is not a system user',
      () {
        final result = ShowStageResultDataInspectorPrecheckUtils
            .checkBeforeShowResultDataInspector(
          stageRouteStatus: StageRouteStatus.active,
          hasResultData: true,
          loggedInUser: regularUser,
        );

        expect(result.yes, isFalse);
        expect(
          result.errCode,
          equals(ShowStageResultDataInspectorPrecheck.userIsNotSystemUser),
        );
      },
    );

    test(
      'Should return yes when stage is active, hasResultData is true, and user is system user',
      () {
        final result = ShowStageResultDataInspectorPrecheckUtils
            .checkBeforeShowResultDataInspector(
          stageRouteStatus: StageRouteStatus.active,
          hasResultData: true,
          loggedInUser: systemUser,
        );

        expect(result.yes, isTrue);
      },
    );
  });
}
