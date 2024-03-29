// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_element, unused_field, return_of_invalid_type, void_checks, annotate_overrides, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api, constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
import 'dart:ffi' as ffi;

/// Bindings for `time.h`.
/// Regenerate bindings with `flutter pub run ffigen --config ffigen.yaml`.
///
class TimeBindings {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  TimeBindings(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  TimeBindings.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  int clock_gettime(
    int clock_id,
    ffi.Pointer<timespec> spec,
  ) {
    return _clock_gettime(
      clock_id,
      spec,
    );
  }

  late final _clock_gettimePtr = _lookup<
          ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Pointer<timespec>)>>(
      'clock_gettime');
  late final _clock_gettime =
      _clock_gettimePtr.asFunction<int Function(int, ffi.Pointer<timespec>)>();
}

class timespec extends ffi.Struct {
  /// seconds
  @ffi.Long()
  external int tv_sec;

  /// nanoseconds
  @ffi.Long()
  external int tv_nsec;
}
