cmake_minimum_required(VERSION 3.4.1)


set(IOS_CLASS_PATH ../../../../ios/Classes)

include_directories(${IOS_CLASS_PATH}/include)

add_library(
        systemclock

        SHARED
        ${IOS_CLASS_PATH}/system_clock.cpp
)

find_library(
        log-lib
        log)

target_link_libraries(
        systemclock
        ${log-lib}
)