cmake_minimum_required(VERSION 3.4.1)


set(SOURCE_CLASS_PATH ../../../../cpp)

include_directories(${SOURCE_CLASS_PATH}/include)

add_library(
        systemclock

        SHARED
        ${SOURCE_CLASS_PATH}/system_clock.cpp
)

find_library(
        log-lib
        log)

target_link_libraries(
        systemclock
        ${log-lib}
)