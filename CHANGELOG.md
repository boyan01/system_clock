## 2.0.2

* Windows: Replace GetTickCount with QueryPerformanceCounter for higher resolution timing (microsecond precision)

## 2.0.1

* fix error when use FLUTTER_TOOL_ARGS="--enable-asserts" flutter pub get

## 2.0.0

* [BREAKING] refactor project on Linux,Android,macOS,iOS to pure dart package for better integration with other projects

## 1.2.0

* the same as 1.2.0-nullsafety.1

## 1.2.0-nullsafety.1

* add linux support

## 1.1.0-nullsafety.1

* fix android/ios/macos/windows build failed.

## 1.1.0-nullsafety.0

* add web support

## 1.0.0-nullsafety.0

* migrate to null safety.

## 0.8.0

* android: retry to load .so library if load failed. fix #4.

## 0.7.0

* android : decrease android gradle plugin to 3.5.0
* ios : fix wrong clock usage. https://github.com/boyan01/system_clock/issues/3
* ios : increase min ios version to 10.0
* docs : add more docs for api method.

## 0.6.0

* fix ios build error

## 0.5.0

* add windows publish script.

## 0.4.1

* fix windows symbol link do not work.

## 0.4.0

* break change. return `Duration` instead.
* add `SystemClock.elapsedRealtime()`.
* support Windows platform.

## 0.0.1

* implement SystemClock.uptimeMills.

## 0.2.0

* publish android dynamic library to github'packages

## 0.3.0

* fix version error

## 0.3.1

* fix build error 