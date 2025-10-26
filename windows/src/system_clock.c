#include "system_clock.h"

int64_t system_clock_GetTickCount()
{
    static LARGE_INTEGER frequency = {0};
    LARGE_INTEGER counter;
    
    // Get the frequency of the performance counter (ticks per second)
    // This is constant for the system, so we cache it
    if (frequency.QuadPart == 0) {
        QueryPerformanceFrequency(&frequency);
    }
    
    // Get the current counter value
    QueryPerformanceCounter(&counter);
    
    // Convert to microseconds: (counter * 1000000) / frequency
    // To avoid overflow, we can rearrange the calculation:
    // If counter is much larger than frequency, we divide first
    // Otherwise, we multiply first for better precision
    if (counter.QuadPart > frequency.QuadPart * 1000) {
        // Large counter values: divide first to avoid overflow
        return (counter.QuadPart / frequency.QuadPart) * 1000000LL + 
               ((counter.QuadPart % frequency.QuadPart) * 1000000LL) / frequency.QuadPart;
    } else {
        // Small counter values: multiply first for better precision
        return (counter.QuadPart * 1000000LL) / frequency.QuadPart;
    }
}