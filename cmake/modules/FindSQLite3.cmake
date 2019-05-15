# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindSQLite3
-----------

Find the SQLite libraries, v3

IMPORTED targets
^^^^^^^^^^^^^^^^

This module defines the following :prop_tgt:`IMPORTED` target:

``SQLite::SQLite3``

Result variables
^^^^^^^^^^^^^^^^

This module will set the following variables if found:

``SQLite3_INCLUDE_DIRS``
  where to find sqlite3.h, etc.
``SQLite3_LIBRARIES``
  the libraries to link against to use SQLite3.
``SQLite3_VERSION``
  version of the SQLite3 library found
``SQLite3_FOUND``
  TRUE if found

#]=======================================================================]

# Look for the necessary header
find_path(SQLite3_INCLUDE_DIR NAMES sqlite3.h)
mark_as_advanced(SQLite3_INCLUDE_DIR)

# Look for the necessary library
set(SQLite3_NAMES ${SQLite3_NAMES} sqlite3 sqlite)
foreach(name ${SQLite3_NAMES})
  list(APPEND SQLite3_NAMES_DEBUG "${name}d")
endforeach()

if(NOT SQLite3_LIBRARY)
  find_library(SQLite3_LIBRARY_RELEASE NAMES ${SQLite3_NAMES})
  find_library(SQLite3_LIBRARY_DEBUG NAMES ${SQLite3_NAMES_DEBUG})
  include(SelectLibraryConfigurations)
  select_library_configurations(SQLite3)
  mark_as_advanced(SQLite3_LIBRARY_RELEASE SQLite3_LIBRARY_DEBUG)
endif()
unset(SQLite3_NAMES)
unset(SQLite3_NAMES_DEBUG)

# Extract version information from the header file
if(SQLite3_INCLUDE_DIR)
    file(STRINGS ${SQLite3_INCLUDE_DIR}/sqlite3.h _ver_line
         REGEX "^#define SQLITE_VERSION  *\"[0-9]+\\.[0-9]+\\.[0-9]+\""
         LIMIT_COUNT 1)
    string(REGEX MATCH "[0-9]+\\.[0-9]+\\.[0-9]+"
           SQLite3_VERSION "${_ver_line}")
    unset(_ver_line)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
find_package_handle_standard_args(SQLite3
    REQUIRED_VARS SQLite3_INCLUDE_DIR SQLite3_LIBRARY
    VERSION_VAR SQLite3_VERSION)

# Create the imported target
if(SQLite3_FOUND)
    set(SQLite3_INCLUDE_DIRS ${SQLite3_INCLUDE_DIR})
    set(SQLite3_LIBRARIES ${SQLite3_LIBRARY})
    if(NOT TARGET SQLite::SQLite3)
        add_library(SQLite::SQLite3 UNKNOWN IMPORTED)
        set_target_properties(SQLite::SQLite3 PROPERTIES
            IMPORTED_LOCATION             "${SQLite3_LIBRARY}"
            IMPORTED_LINK_INTERFACE_LANGUAGES "C"
            INTERFACE_INCLUDE_DIRECTORIES "${SQLite3_INCLUDE_DIR}")
        if(EXISTS "${SQLite3_LIBRARY_RELEASE}")
            set_property(TARGET SQLite::SQLite3 APPEND PROPERTY
              IMPORTED_CONFIGURATIONS RELEASE)
            set_target_properties(SQLite::SQLite3 PROPERTIES
              IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
              IMPORTED_LOCATION_RELEASE "${SQLite3_LIBRARY_RELEASE}")
        endif()
        if(EXISTS "${SQLite3_LIBRARY_DEBUG}")
            set_property(TARGET SQLite::SQLite3 APPEND PROPERTY
              IMPORTED_CONFIGURATIONS DEBUG)
            set_target_properties(SQLite::SQLite3 PROPERTIES
              IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "C"
              IMPORTED_LOCATION_DEBUG "${SQLite3_LIBRARY_DEBUG}")
        endif()
    endif()
endif()
