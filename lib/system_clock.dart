// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:ffi';
import 'dart:io';

class SystemClock {
  static final _library = Platform.isAndroid
      ? DynamicLibrary.open("libsystemclock.so")
      : DynamicLibrary.process();

  static final int Function() _uptime = _library
      .lookup<NativeFunction<Int64 Function()>>("system_clock_uptimeMills")
      .asFunction();

  static int get uptime {
    return _uptime();
  }
}
