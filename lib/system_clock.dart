import 'dart:ffi';
import 'dart:io';

typedef _ClockFunction = int Function();

_ClockFunction _lookupClockFunc(DynamicLibrary library, String symbol) {
  return library.lookup<NativeFunction<Int64 Function()>>(symbol).asFunction();
}

DynamicLibrary _openLibrary() {
  if (Platform.isAndroid) {
    return DynamicLibrary.open("libsystemclock.so");
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open("system_clock_plugin.dll");
  }
  return DynamicLibrary.process();
}

///
/// timekeeping facilities.
///
class SystemClock {
  SystemClock._internal();

  static final _library = _openLibrary();

  static final _ClockFunction _uptime = _lookupClockFunc(_library, "system_clock_uptime");
  static final _ClockFunction _elapsedRealtime = _lookupClockFunc(_library, "system_clock_elapsed_realtime");

  ///
  /// Duration since boot, not counting time spent in deep sleep.
  ///
  static Duration uptime() {
    return Duration(microseconds: _uptime());
  }

  ///
  /// Duration since boot, including time spent in sleep.
  ///
  static Duration elapsedRealtime() {
    return Duration(microseconds: _elapsedRealtime());
  }
}
