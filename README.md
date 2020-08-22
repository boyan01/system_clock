# system_clock

A Flutter tools to get system clock.

## Getting Started

```dart

import 'package:system_clock/system_clock.dart';

print("current uptime in mills: ${SystemClock.uptimeMills}")

```

## Refs

https://android.googlesource.com/platform/frameworks/base/+/56a2301/core/java/android/os/SystemClock.java
https://android.googlesource.com/platform/frameworks/base/+/master/core/jni/android_os_SystemClock.cpp
https://android.googlesource.com/platform/frameworks/native/+/android-4.2.2_r1/include/utils/Timers.h
https://android.googlesource.com/platform/system/core/+/master/libutils/Timers.cpp