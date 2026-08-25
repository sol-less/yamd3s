cmake_minimum_required(VERSION 3.16)
project(yamd3s)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Qml)

function(create_qml_module FOLDER_NAME MODULE_SUFFIX IS_SINGLETON)
    set(MODULE_NAME "Y3s/${MODULE_SUFFIX}")
    set(MODULE_DIR "${CMAKE_BINARY_DIR}/${MODULE_NAME}")
    file(MAKE_DIRECTORY "${MODULE_DIR}")

    file(GLOB QML_FILES "${CMAKE_SOURCE_DIR}/${FOLDER_NAME}/*.qml")
    
    set(QMLDIR_CONTENT "module Y3s.${MODULE_SUFFIX}\n")

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

create_qml_module("globals" "Globals" TRUE)
create_qml_module("tokens" "Tokens" TRUE)
create_qml_module("lib" "Lib" FALSE)

qt_add_qml_module(Y3sConfigPlugin
    URI "Y3s.Config"
    VERSION 1.0
    OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/Y3s/Config"
    SOURCES
        src/ConfigManager.h
        src/ConfigManager.cpp
        src/SystemMonitor.h
        src/SystemMonitor.cpp
        src/Theme.h
        src/Theme.cpp
)

target_include_directories(Y3sConfigPlugin PRIVATE src)
