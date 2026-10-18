
# - Try to find the Gcrypt library
# Once run this will define
#
#  LIBGCRYPT_FOUND - set if the system has the gcrypt library
#  LIBGCRYPT_CFLAGS - the required gcrypt compilation flags
#  LIBGCRYPT_LIBRARIES - the linker libraries needed to use the gcrypt library
#
# Copyright (c) 2006 Brad Hards <bradh@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

# libgcrypt is moving to pkg-config, but earlier version don't have it

find_package(PkgConfig QUIET)
if (PkgConfig_FOUND)
  pkg_check_modules(LIBGCRYPT QUIET IMPORTED_TARGET libgcrypt)
endif ()

if (LIBGCRYPT_FOUND)
  if (NOT LibGcrypt_FIND_QUIETLY)
    message(STATUS "Found libgcrypt: ${LIBGCRYPT_LIBRARIES}")
  endif ()
  set(LIBGCRYPT_LIBRARIES PkgConfig::LIBGCRYPT)
  return()
endif ()

#search in typical paths for libgcrypt-config
FIND_PROGRAM(LIBGCRYPTCONFIG_EXECUTABLE NAMES libgcrypt-config)

#reset variables
set(LIBGCRYPT_LIBRARIES)
set(LIBGCRYPT_CFLAGS)

# if libgcrypt-config has been found
IF(LIBGCRYPTCONFIG_EXECUTABLE)

  execute_process(COMMAND ${LIBGCRYPTCONFIG_EXECUTABLE} --libs
    RESULT_VARIABLE _libs_result OUTPUT_VARIABLE LIBGCRYPT_LIBRARIES
    OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND ${LIBGCRYPTCONFIG_EXECUTABLE} --cflags
    RESULT_VARIABLE _cflags_result OUTPUT_VARIABLE LIBGCRYPT_CFLAGS
    OUTPUT_STRIP_TRAILING_WHITESPACE)

  string(REPLACE "fgrep: warning: fgrep is obsolescent; using grep -F" "" LIBGCRYPT_LIBRARIES "${LIBGCRYPT_LIBRARIES}")
  string(STRIP "${LIBGCRYPT_LIBRARIES}" LIBGCRYPT_LIBRARIES)

  IF("${LIBGCRYPT_CFLAGS}" MATCHES "\n")
    SET(LIBGCRYPT_CFLAGS " ")
  ENDIF()

  IF(_libs_result EQUAL 0 AND _cflags_result EQUAL 0 AND LIBGCRYPT_LIBRARIES)
    SET(LIBGCRYPT_FOUND TRUE)
  ENDIF()

ENDIF(LIBGCRYPTCONFIG_EXECUTABLE)

if (LIBGCRYPT_FOUND)
   if (NOT LibGcrypt_FIND_QUIETLY)
      message(STATUS "Found libgcrypt: ${LIBGCRYPT_LIBRARIES}")
   endif (NOT LibGcrypt_FIND_QUIETLY)
else (LIBGCRYPT_FOUND)
   if (LibGcrypt_FIND_REQUIRED)
      message(FATAL_ERROR "Could not find libgcrypt libraries")
   endif (LibGcrypt_FIND_REQUIRED)
endif (LIBGCRYPT_FOUND)

MARK_AS_ADVANCED(LIBGCRYPT_CFLAGS LIBGCRYPT_LIBRARIES)
