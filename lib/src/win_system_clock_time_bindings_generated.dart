// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_element, unused_field, return_of_invalid_type, void_checks, annotate_overrides, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api, constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
import 'dart:ffi' as ffi;

/// Bindings for `windows/src/system_clock.h`.
/// Regenerate bindings with `flutter pub run ffigen --config ffigen-win.yaml`.
///
class WinClockBindings {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  WinClockBindings(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  WinClockBindings.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  int system_clock_GetTickCount() {
    return _system_clock_GetTickCount();
  }

  late final _system_clock_GetTickCountPtr =
      _lookup<ffi.NativeFunction<ffi.Int64 Function()>>(
          'system_clock_GetTickCount');
  late final _system_clock_GetTickCount =
      _system_clock_GetTickCountPtr.asFunction<int Function()>();
}
