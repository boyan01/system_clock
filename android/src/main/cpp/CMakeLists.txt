cmake_minimum_required(VERSION 3.4.1)

include_directories(include)

add_library(
        systemclock

        SHARED
        system_clock.cpp
)

find_library(
        log-lib
        log)

target_link_libraries(
        systemclock
        ${log-lib}
)