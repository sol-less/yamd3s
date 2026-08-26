cmake_minimum_required(VERSION 3.16)
project(yamd3s)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)

include(FetchContent)
FetchContent_Declare(
    tomlplusplus
    GIT_REPOSITORY https://github.com/marzer/tomlplusplus.git
    GIT_TAG        v3.4.0
)
FetchContent_MakeAvailable(tomlplusplus)


if(COMMAND qt_policy)
    qt_policy(SET QTP0001 NEW)
endif()

find_package(Qt6 REQUIRED COMPONENTS Core Qml Quick)

function(create_qml_module FOLDER_NAME MODULE_SUFFIX IS_SINGLETON)
    set(MODULE_NAME "Yamd3s/${MODULE_SUFFIX}")
    set(MODULE_DIR "${CMAKE_BINARY_DIR}/${MODULE_NAME}")
    file(MAKE_DIRECTORY "${MODULE_DIR}")

    file(GLOB QML_FILES "${CMAKE_SOURCE_DIR}/${FOLDER_NAME}/*.qml")
    
    set(QMLDIR_CONTENT "module Yamd3s.${MODULE_SUFFIX}\n")

    foreach(QML_FILE ${QML_FILES})
        get_filename_component(FILE_NAME ${QML_FILE} NAME)
        get_filename_component(FILE_WE ${QML_FILE} NAME_WE)

        if(IS_SINGLETON)
            string(APPEND QMLDIR_CONTENT "singleton ${FILE_WE} 1.0 ${FILE_NAME}\n")
        else()
            string(APPEND QMLDIR_CONTENT "${FILE_WE} 1.0 ${FILE_NAME}\n")
        endif()

        file(CREATE_LINK "${QML_FILE}" "${MODULE_DIR}/${FILE_NAME}" SYMBOLIC)
    endforeach()

    file(WRITE "${MODULE_DIR}/qmldir" "${QMLDIR_CONTENT}")
endfunction()

create_qml_module("qml/globals" "Globals" TRUE)
create_qml_module("qml/components" "UI" FALSE)

qt_add_qml_module(Yamd3sCorePlugin
    URI "Yamd3s.Core"
    VERSION 1.0
    OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/Yamd3s/Core"
    SOURCES
        src/core/ConfigManager.cpp
        src/core/ConfigManager.h
        src/core/SystemMonitor.h
        src/core/SystemMonitor.cpp
        src/core/Theme.h
        src/core/Theme.cpp
)

qt_add_qml_module(Yamd3sVisualPlugin
    URI "Yamd3s.Visual"
    VERSION 1.0
    OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/Yamd3s/Visual"
    SOURCES
        src/visual/Corner.h
        src/visual/Corner.cpp
)

target_include_directories(Yamd3sCorePlugin PRIVATE 
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/src/core
)

target_include_directories(Yamd3sVisualPlugin PRIVATE 
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/src/visual
)

target_link_libraries(Yamd3sVisualPlugin PRIVATE Qt6::Quick)
target_link_libraries(Yamd3sCorePlugin PRIVATE Qt6::Qml tomlplusplus::tomlplusplus)