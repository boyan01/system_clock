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

#elif _WIN32
#include <Windows.h>
nsecs_t system_clock_systemTime(int clock)
{
    checkClockId(clock);
    int64_t tick = static_cast<int64_t>(GetTickCount());
    return tick * 1000000LL;
}

#endif
