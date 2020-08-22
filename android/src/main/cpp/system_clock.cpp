#include "include/system_clock/system_clock.h"

#include <sys/types.h>
#include <sys/sysinfo.h>
#include <ctime>
#include <cstdlib>

int64_t system_clock_uptimeMills() {
    return nanoseconds_to_milliseconds(system_clock_uptimeNanos());
}


int64_t system_clock_uptimeNanos() {
    return system_clock_systemTime(SYSTEM_TIME_MONOTONIC);
}

static constexpr size_t clock_id_max = 5;

static void checkClockId(int clock) {
    if (clock < 0 || clock >= clock_id_max) abort();
}


#if defined(__linux__)

nsecs_t system_clock_systemTime(int clock) {
    checkClockId(clock);
    static constexpr clockid_t clocks[] = {CLOCK_REALTIME, CLOCK_MONOTONIC,
                                           CLOCK_PROCESS_CPUTIME_ID, CLOCK_THREAD_CPUTIME_ID,
                                           CLOCK_BOOTTIME};
    timespec t = {};
    clock_gettime(clocks[clock], &t);
    return nsecs_t(t.tv_sec) * 1000000000LL + t.tv_nsec;
}

#else
nsecs_t system_clock_systemTime(int clock) {
    // TODO: is this ever called with anything but REALTIME on mac/windows?
    checkClockId(clock);
    // Clock support varies widely across hosts. Mac OS doesn't support
    // CLOCK_BOOTTIME (and doesn't even have clock_gettime until 10.12).
    // Windows is windows.
    timeval t = {};
    gettimeofday(&t, nullptr);
    return nsecs_t(t.tv_sec)*1000000000LL + nsecs_t(t.tv_usec)*1000LL;
}
#endif