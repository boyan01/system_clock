library system_clock;

import 'src/clock.dart' if (dart.library.io) 'src/clock_io.dart' as clock;

///
/// timekeeping facilities.
///
class SystemClock {
  SystemClock._internal();

  ///
  /// Duration since boot, not counting time spent in deep sleep.
  ///
  static Duration uptime() {
    return clock.uptime();
  }

  ///
  /// Duration since boot, including time spent in sleep.
  ///
  static Duration elapsedRealtime() {
    return clock.elapsedRealtime();
  }
}
