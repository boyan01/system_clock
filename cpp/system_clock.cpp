#include "include/system_clock.h"

#ifndef __PLUGINS_SYSTEM_CLOCK_
#include "include/system_clock.mm"
#endif

#include <sys/types.h>
#include <ctime>
#include <cstdlib>

int64_t system_clock_uptime()
{
    return nanoseconds_to_microseconds(system_clock_systemTime(SYSTEM_CLOCK_UPTTIME));
}

int64_t system_clock_elapsed_realtime()
{
    return nanoseconds_to_microseconds(system_clock_systemTime(SYSTEM_CLOCK_ELLAPSED_REALTIME));
}

static constexpr size_t clock_id_max = 2;

static void checkClockId(int clock)
{
    if (clock < 0 || clock >= clock_id_max)
        abort();
}

#if defined(__linux__) || defined(__APPLE__)

#ifdef __linux__
#include <sys/sysinfo.h>
#endif

nsecs_t system_clock_systemTime(int clock)
{
    checkClockId(clock);
#ifdef __linux__
    static constexpr clockid_t clocks[] = {CLOCK_BOOTTIME, CLOCK_MONOTONIC};
#else
    static constexpr clockid_t clocks[] = {CLOCK_MONOTONIC, CLOCK_UPTIME_RAW};
#endif
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
