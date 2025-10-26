#include "system_clock.h"

int64_t system_clock_GetTickCount()
{
    LARGE_INTEGER frequency;
    LARGE_INTEGER counter;
    
    // Get the frequency of the performance counter (ticks per second)
    QueryPerformanceFrequency(&frequency);
    
    // Get the current counter value
    QueryPerformanceCounter(&counter);
    
    // Convert to microseconds: (counter * 1000000) / frequency
    // Using integer arithmetic to avoid floating point
    return (counter.QuadPart * 1000000LL) / frequency.QuadPart;
}