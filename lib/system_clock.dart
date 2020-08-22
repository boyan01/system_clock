import 'dart:ffi';
import 'dart:io';

///
/// timekeeping facilities.
///
class SystemClock {
  static final _library = Platform.isAndroid
      ? DynamicLibrary.open("libsystemclock.so")
      : DynamicLibrary.process();

  static final int Function() _uptime = _library
      .lookup<NativeFunction<Int64 Function()>>("system_clock_uptimeMills")
      .asFunction();

  ///
  /// Returns milliseconds since boot, not counting time spent in deep sleep.
  ///
  /// Note: This value may get reset occasionally (before it would otherwise wrap around).
  ///
  static int get uptimeMills {
    return _uptime();
  }
}
