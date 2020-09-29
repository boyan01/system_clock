#ifndef __PLUGINS_SYSTEM_CLOCK_
#define __PLUGINS_SYSTEM_CLOCK_

#include <stdint.h>

#if !_WIN32
#define _SYSTEM_CLOCK_DART_EXPORT extern "C" __attribute__((visibility("default"))) __attribute__((used))
#else
#define _SYSTEM_CLOCK_DART_EXPORT extern "C" __declspec(dllexport)
#endif //OS_Windows

typedef int64_t nsecs_t; // nano-seconds

enum {
    SYSTEM_CLOCK_ELLAPSED_REALTIME = 0, // time since boot, including time spent in sleep.
    SYSTEM_CLOCK_UPTTIME           = 1 // time since boot, not counting time spent in deep sleep.
};

_SYSTEM_CLOCK_DART_EXPORT
int64_t system_clock_uptime();

_SYSTEM_CLOCK_DART_EXPORT
int64_t system_clock_elapsed_realtime();

nsecs_t system_clock_systemTime(int clock);

static inline nsecs_t nanoseconds_to_microseconds(nsecs_t secs)
{
    return secs / 1000;
}

#endif // PLUGINS_SYSTEM_CLOCK_
