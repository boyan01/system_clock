///
/// Duration since boot, not counting time spent in deep sleep.
///
Duration uptime() {
  return Duration(milliseconds: DateTime.now().millisecondsSinceEpoch);
}

///
/// Duration since boot, including time spent in sleep.
///
Duration elapsedRealtime() {
  return Duration(milliseconds: DateTime.now().millisecondsSinceEpoch);
}
