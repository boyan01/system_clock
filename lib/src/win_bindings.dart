// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';

final _kernel32 = DynamicLibrary.open('kernel32.dll');

int QueryPerformanceCounter(Pointer<Int64> lpPerformanceCount) =>
    _QueryPerformanceCounter(lpPerformanceCount);

final _QueryPerformanceCounter = _kernel32.lookupFunction<
    Int32 Function(Pointer<Int64> lpPerformanceCount),
    int Function(Pointer<Int64> lpPerformanceCount)>('QueryPerformanceCounter');

int QueryPerformanceFrequency(Pointer<Int64> lpFrequency) =>
    _QueryPerformanceFrequency(lpFrequency);

final _QueryPerformanceFrequency = _kernel32.lookupFunction<
    Int32 Function(Pointer<Int64> lpFrequency),
    int Function(Pointer<Int64> lpFrequency)>('QueryPerformanceFrequency');
