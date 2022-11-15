#include "system_clock.h"

int64_t system_clock_GetTickCount()
{
    return (int64_t)GetTickCount();
}