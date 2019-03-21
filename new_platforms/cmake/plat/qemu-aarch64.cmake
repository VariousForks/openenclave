# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

include(${CMAKE_CURRENT_LIST_DIR}/../linux-aarch64-v6.cmake)

# When using GCC to compile assembly files.
set(OE_TA_S_FLAGS
    -DASM=1
    -pipe
)

if("${CMAKE_BUILD_TYPE}" STREQUAL "" OR "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    list(APPEND OE_TA_S_FLAGS -g)
endif()

# When using GCC to compile C/CXX files.
set(OE_TA_COMMON_DEFINITIONS
    -D_XOPEN_SOURCE=700
    -DARM64=1
    -D__LP64__=1)

set(OE_TA_COMMON_FLAGS
    -mstrict-align
    -nostdinc
    -nostdlib
    -nodefaultlibs
    -nostartfiles
    -fno-builtin-memcpy
    -fno-builtin-memset
    -ffreestanding
    -fpie
    -fPIC)

if("${CMAKE_BUILD_TYPE}" STREQUAL "" OR "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    list(APPEND OE_TA_COMMON_FLAGS -g3)
else()
    list(APPEND OE_TA_COMMON_FLAGS -Os)
endif()

# When using GCC for linking.
set(OE_TA_LINKER_FLAGS
    -fpie
    --sort-section=alignment)

# Final values.
set(OE_TA_C_FLAGS
    ${OE_TA_COMMON_DEFINITIONS}
    ${OE_TA_COMMON_FLAGS})
set(OE_TA_CXX_FLAGS
    ${OE_TA_COMMON_DEFINITIONS}
    ${OE_TA_COMMON_FLAGS})
set(OE_TA_LD_FLAGS
    ${OE_TA_LINKER_FLAGS})