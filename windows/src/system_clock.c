#include "system_clock.h"

// Threshold multiplier for overflow protection
#define OVERFLOW_THRESHOLD_MULTIPLIER 1000

int64_t system_clock_GetTickCount()
{
    static LARGE_INTEGER frequency = {0};
    LARGE_INTEGER counter;
    
    // Get the frequency of the performance counter (ticks per second)
    // This is constant for the system, so we cache it
    if (frequency.QuadPart == 0) {
        if (!QueryPerformanceFrequency(&frequency) || frequency.QuadPart == 0) {
            // QueryPerformanceFrequency should never fail on Windows XP and later,
            // but handle it just in case by returning 0
            return 0;
        }
    }
    
    // Get the current counter value
    if (!QueryPerformanceCounter(&counter)) {
        // QueryPerformanceCounter should never fail on Windows XP and later,
        // but handle it just in case by returning 0
        return 0;
    }
    
    // Convert to microseconds: (counter * 1000000) / frequency
    // To avoid overflow, we can rearrange the calculation:
    // If counter is much larger than frequency, we divide first
    // Otherwise, we multiply first for better precision
    if (counter.QuadPart > frequency.QuadPart * OVERFLOW_THRESHOLD_MULTIPLIER) {
        // Large counter values: divide first to avoid overflow
        return (counter.QuadPart / frequency.QuadPart) * 1000000LL + 
               ((counter.QuadPart % frequency.QuadPart) * 1000000LL) / frequency.QuadPart;
    } else {
        // Small counter values: multiply first for better precision
        return (counter.QuadPart * 1000000LL) / frequency.QuadPart;
    }
}