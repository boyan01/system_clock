import 'dart:ffi';
import 'dart:io';

typedef _ClockFunction = int Function();

_ClockFunction _lookupClockFunc(DynamicLibrary library, String symbol) {
  return library.lookup<NativeFunction<Int64 Function()>>(symbol).asFunction();
}

///
/// timekeeping facilities.
///
class SystemClock {
  SystemClock._internal();

  static final _library = Platform.isAndroid ? DynamicLibrary.open("libsystemclock.so") : DynamicLibrary.process();

  static final _ClockFunction _uptime = _lookupClockFunc(_library, "system_clock_uptime");
  static final _ClockFunction _elapsedRealtime = _lookupClockFunc(_library, "system_clock_elapsed_realtime");

  ///
  /// Returns milliseconds since boot, not counting time spent in deep sleep.
  ///
  /// Note: This value may get reset occasionally (before it would otherwise wrap around).
  ///
  static Duration uptime() {
    return Duration(microseconds: _uptime());
  }

  static Duration elapsedRealtime() {
    return Duration(microseconds: _elapsedRealtime());
  }
}
