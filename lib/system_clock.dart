import 'dart:ffi';
import 'dart:io';
import 'dart:math';

typedef _ClockFunction = int Function();

_ClockFunction _lookupClockFunc(DynamicLibrary library, String symbol) {
  return library.lookup<NativeFunction<Int64 Function()>>(symbol).asFunction();
}

DynamicLibrary _openLibrary() {
  if (Platform.isAndroid) {
    try {
      return DynamicLibrary.open("libsystemclock.so");
    } catch (_) {
      // On some (especially old) Android devices, we somehow can't dlopen
      // libraries shipped with the apk. We need to find the full path of the
      // library (/data/data/<id>/lib/xxx.so) and open that one.
      // For details, see https://github.com/simolus3/moor/issues/420
      final appIdAsBytes = File('/proc/self/cmdline').readAsBytesSync();

      // app id ends with the first \0 character in here.
      final endOfAppId = max(appIdAsBytes.indexOf(0), 0);
      final appId = String.fromCharCodes(appIdAsBytes.sublist(0, endOfAppId));

      return DynamicLibrary.open('/data/data/$appId/lib/libsystemclock.so');
    }
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
