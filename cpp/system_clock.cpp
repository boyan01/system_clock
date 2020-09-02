#include "include/system_clock.h"

#ifndef __PLUGINS_SYSTEM_CLOCK_
#include "include/system_clock.mm"
#endif

#include <sys/types.h>
#include <ctime>
#include <cstdlib>

int64_t system_clock_uptime()
{
    return nanoseconds_to_microseconds(system_clock_systemTime(SYSTEM_TIME_MONOTONIC));
}

int64_t system_clock_elapsed_realtime()
{
    return nanoseconds_to_microseconds(system_clock_systemTime(SYSTEM_TIME_BOOTTIME));
}

static constexpr size_t clock_id_max = 5;

static void checkClockId(int clock)
{
    if (clock < 0 || clock >= clock_id_max)
        abort();
}

#if defined(__linux__) || defined(__APPLE__)
#ifdef __linux__
#include <sys/sysinfo.h>
#endif
#ifdef __APPLE__
#ifndef CLOCK_BOOTTIME
#define CLOCK_BOOTTIME CLOCK_UPTIME_RAW
#endif
#endif
nsecs_t system_clock_systemTime(int clock)
{
    checkClockId(clock);
    static constexpr clockid_t clocks[] = {CLOCK_REALTIME, CLOCK_MONOTONIC,
                                           CLOCK_PROCESS_CPUTIME_ID, CLOCK_THREAD_CPUTIME_ID,
                                           CLOCK_BOOTTIME};
    timespec t = {};
    clock_gettime(clocks[clock], &t);
    return nsecs_t(t.tv_sec) * 1000000000LL + t.tv_nsec;
}

#elif __APPLE__

#include "TargetConditionals.h"
#include <sys/sysctl.h>
#include <sys/time.h>

#if TARGET_OS_IPHONE
nsecs_t system_clock_systemTime(int clock)
{
    checkClockId(clock);
    // Clock support varies widely across hosts. Mac OS doesn't support
    // CLOCK_BOOTTIME (and doesn't even have clock_gettime until 10.12).
    // Windows is windows.
    timeval t = {};
    gettimeofday(&t, nullptr);
    return nsecs_t(t.tv_sec) * 1000000000LL + nsecs_t(t.tv_usec) * 1000LL;
}
#elif TARGET_OS_OSX
nsecs_t system_clock_uptimeNanos(int clock)
{
    checkClockId(clock);
    if (clock != SYSTEM_TIME_BOOTTIME)
    {
        abort();
    }
    timeval boottime = {};
    size_t len = sizeof(timeval);
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    if (sysctl(mib, 2, &boottime, &len, nullptr, 0) < 0)
    {
        return -1;
    }
}
#endif

#endif
