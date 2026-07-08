part of '../core.dart';

abstract class FaClock {
  DateTime now();

  void advance(Duration duration);
}

class FaSystemClock implements FaClock {
  const FaSystemClock();

  @override
  DateTime now() => DateTime.now();

  @override
  void advance(Duration duration) {
    // Do nothing.
  }
}

class FaFakeClock implements FaClock {
  DateTime current;

  FaFakeClock(this.current);

  @override
  DateTime now() => current;

  @override
  void advance(Duration duration) {
    current = current.add(duration);
  }
}
