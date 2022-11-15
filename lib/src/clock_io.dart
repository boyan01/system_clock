import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'c_time_bindings_generated.dart';
import 'package:ffi/ffi.dart';

DynamicLibrary _openLibrary() {
  if (Platform.isAndroid) {
    try {
      return DynamicLibrary.open('libc.so');
    } catch (e) {
      print('Failed to open libc.so');
    }
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open("system_clock_plugin.dll");
  }
  return DynamicLibrary.process();
}

final _library = _openLibrary();

final _binding = TimeBindings(_library);

final _isLinux = Platform.isLinux || Platform.isAndroid;

///
/// Duration since boot, not counting time spent in deep sleep.
///
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

///
/// Duration since boot, including time spent in sleep.
///
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
