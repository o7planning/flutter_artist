import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockStage implements Stage {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('StageRestartPrecheckUtils Tests', () {
    final mockStage = _MockStage();

    test('Should return busy when checkBusy is true and isBusy is true', () {
      final result = StageRestartPrecheckUtils.checkBeforeRestartStage(
        checkBusy: true,
        isBusy: true,
        targetStage: mockStage,
        isRestartAllowed: true,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageRestartPrecheck.busy));
    });

    test('Should return noTargetStage when targetStage is null', () {
      final result = StageRestartPrecheckUtils.checkBeforeRestartStage(
        checkBusy: true,
        isBusy: false,
        targetStage: null,
        isRestartAllowed: true,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageRestartPrecheck.noTargetStage));
    });

    test('Should return notAllowed when isRestartAllowed is false', () {
      final result = StageRestartPrecheckUtils.checkBeforeRestartStage(
        checkBusy: true,
        isBusy: false,
        targetStage: mockStage,
        isRestartAllowed: false,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageRestartPrecheck.notAllowed));
    });

    test('Should return yes when all conditions pass', () {
      final result = StageRestartPrecheckUtils.checkBeforeRestartStage(
        checkBusy: true,
        isBusy: false,
        targetStage: mockStage,
        isRestartAllowed: true,
      );

      expect(result.yes, isTrue);
    });
  });
}
