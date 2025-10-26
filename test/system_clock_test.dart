import 'package:test/test.dart';
import 'package:system_clock/system_clock.dart';

void main() {
  test('get time', () {
    print(SystemClock.uptime().toString());
    print(SystemClock.elapsedRealtime().toString());
  });
}
