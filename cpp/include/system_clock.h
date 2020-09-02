#ifndef __PLUGINS_SYSTEM_CLOCK_
#define __PLUGINS_SYSTEM_CLOCK_

#include <stdint.h>

#if !_WIN32
#define DART_EXPORT extern "C" __attribute__((visibility("default"))) __attribute__((used))
#else
#define DART_EXPORT extern "C" __declspec(dllexport)
#endif //OS_Windows

typedef int64_t nsecs_t; // nano-seconds

enum
{
    SYSTEM_TIME_REALTIME = 0,  // system-wide realtime clock
    SYSTEM_TIME_MONOTONIC = 1, // monotonic time since unspecified starting point
    SYSTEM_TIME_PROCESS = 2,   // high-resolution per-process clock
    SYSTEM_TIME_THREAD = 3,    // high-resolution per-thread clock
    SYSTEM_TIME_BOOTTIME = 4   // same as SYSTEM_TIME_MONOTONIC, but including CPU suspend time
};

DART_EXPORT
int64_t system_clock_uptime();

DART_EXPORT
int64_t system_clock_elapsed_realtime();

nsecs_t system_clock_systemTime(int clock);

static inline nsecs_t nanoseconds_to_microseconds(nsecs_t secs)
{
    return secs / 1000;
}

#endif // PLUGINS_SYSTEM_CLOCK_
