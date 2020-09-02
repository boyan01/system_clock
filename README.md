# system_clock

[![Pub](https://img.shields.io/pub/v/system_clock.svg)](https://pub.dartlang.org/packages/system_clock)

Flutter timekeeping facilities, powered by `dart:ffi`.

support: Android、iOS、Macos

wip: linux, Windows

## Getting Started

```dart
import 'package:system_clock/system_clock.dart';

void main() {
  println("system uptime: ${SystemClock.uptime()}");
  println("system elapsed realtime: ${SystemClock.elapsedRealtime()}");
}

```

## Refs

https://android.googlesource.com/platform/frameworks/base/+/56a2301/core/java/android/os/SystemClock.java
https://android.googlesource.com/platform/frameworks/base/+/master/core/jni/android_os_SystemClock.cpp
https://android.googlesource.com/platform/frameworks/native/+/android-4.2.2_r1/include/utils/Timers.h
https://android.googlesource.com/platform/system/core/+/master/libutils/Timers.cpp
