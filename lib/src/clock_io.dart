import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'c_time_bindings_generated.dart';
import 'win_bindings.dart';

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
  static int? _frequency;
  static const _overflowThresholdMultiplier = 1000;

  @override
  Duration uptime() {
    // Get the frequency of the performance counter (ticks per second)
    // This is constant for the system, so we cache it
    if (_frequency == null) {
      final freq = malloc<Int64>();
      if (QueryPerformanceFrequency(freq) == 0 || freq.value == 0) {
        malloc.free(freq);
        return Duration.zero;
      }
      _frequency = freq.value;
      malloc.free(freq);
    }

    // Get the current counter value
    final counter = malloc<Int64>();
    if (QueryPerformanceCounter(counter) == 0) {
      malloc.free(counter);
      return Duration.zero;
    }

    final counterValue = counter.value;
    malloc.free(counter);

    // Convert to microseconds: (counter * 1000000) / frequency
    // To avoid overflow, we rearrange the calculation:
    // If counter is much larger than frequency, we divide first
    // Otherwise, we multiply first for better precision
    final int microseconds;
    if (counterValue > _frequency! * _overflowThresholdMultiplier) {
      // Large counter values: divide first to avoid overflow
      final quotient = counterValue ~/ _frequency!;
      final remainder = counterValue % _frequency!;
      microseconds = quotient * 1000000 + (remainder * 1000000) ~/ _frequency!;
    } else {
      // Small counter values: multiply first for better precision
      microseconds = (counterValue * 1000000) ~/ _frequency!;
    }

    return Duration(microseconds: microseconds);
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
