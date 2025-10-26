import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'c_time_bindings_generated.dart';
import 'win_system_clock_time_bindings_generated.dart';

abstract class SystemClock {
  /// Duration since boot, not counting time spent in deep sleep.
  Duration uptime();

  /// Duration since boot, including time spent in sleep.
  Duration elapsedRealtime();
}

class UnixSystemClock implements SystemClock {
  final _binding = TimeBindings(DynamicLibrary.process());

  final _isLinux = Platform.isLinux || Platform.isAndroid;

  @override
  Duration uptime() {
    final ts = malloc<timespec>();

    if (_isLinux) {
      // CLOCK_MONOTONIC
      _binding.clock_gettime(1, ts);
    } else {
      // CLOCK_UPTIME_RAW
      _binding.clock_gettime(8, ts);
    }
    final d = ts.ref.tv_sec * 1000000000 + ts.ref.tv_nsec;
    malloc.free(ts);
    return Duration(microseconds: d ~/ 1000);
  }

  @override
  Duration elapsedRealtime() {
    final ts = malloc<timespec>();

    if (_isLinux) {
      // CLOCK_BOOTTIME
      _binding.clock_gettime(7, ts);
    } else {
      // CLOCK_MONOTONIC
      _binding.clock_gettime(6, ts);
    }
    final d = ts.ref.tv_sec * 1000000000 + ts.ref.tv_nsec;
    malloc.free(ts);
    return Duration(microseconds: d ~/ 1000);
  }
}

class WinSystemClock implements SystemClock {
  final _binding = WinClockBindings(DynamicLibrary.open('system_clock.dll'));

  @override
  Duration uptime() {
    final d = _binding.system_clock_GetTickCount();
    return Duration(microseconds: d);
  }

  @override
  Duration elapsedRealtime() {
    return uptime();
  }
}

final SystemClock systemClock =
    Platform.isWindows ? WinSystemClock() : UnixSystemClock();

Duration uptime() => systemClock.uptime();

Duration elapsedRealtime() => systemClock.elapsedRealtime();
