cmake_minimum_required(VERSION 3.19)
project(Yamd3s)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)

include(GNUInstallDirs)

set(INSTALL_QMLDIR "${CMAKE_INSTALL_LIBDIR}/qt6/qml")
set(INSTALL_QSCONFDIR "${CMAKE_INSTALL_SYSCONFDIR}/xdg/quickshell/yamd3s")

include(FetchContent)
FetchContent_Declare(
    tomlplusplus
    GIT_REPOSITORY https://github.com/marzer/tomlplusplus.git
    GIT_TAG        v3.4.0
)
FetchContent_MakeAvailable(tomlplusplus)

find_package(Qt6 REQUIRED COMPONENTS Core Qml Quick)

if(COMMAND qt_policy)
    qt_policy(SET QTP0001 NEW)
    qt_policy(SET QTP0004 NEW)
endif()

set_source_files_properties(
    src/globals/MatugenService.qml
    src/globals/PowerActions.qml
    src/globals/States.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(Yamd3s
    URI "Yamd3s"
    VERSION 1.0
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/Yamd3s"
    SOURCES
        src/core/ConfigManager.cpp src/core/ConfigManager.h
        src/core/SystemMonitor.cpp src/core/SystemMonitor.h
        src/core/Theme.cpp src/core/Theme.h
        src/visual/Corner.cpp src/visual/Corner.h
    QML_FILES
        src/globals/MatugenService.qml
        src/globals/PowerActions.qml
        src/globals/States.qml
        src/components/Button.qml
        src/components/Progress.qml
        src/components/QuickButton.qml
        src/components/RangeSlider.qml
        src/components/ControlSlider.qml
        src/components/Switch.qml
    RESOURCES
        src/configuration/system.json
)

target_include_directories(Yamd3s PRIVATE src/core src/visual)
target_link_libraries(Yamd3s
    PRIVATE
        Qt6::Core
        Qt6::Qml
        Qt6::Quick
        tomlplusplus::tomlplusplus
)

if(TARGET Yamd3splugin)
    set_target_properties(Yamd3splugin PROPERTIES INSTALL_RPATH "$ORIGIN")
endif()
set_target_properties(Yamd3s PROPERTIES INSTALL_RPATH "$ORIGIN")

install(TARGETS Yamd3s Yamd3splugin
    DESTINATION "${INSTALL_QMLDIR}/Yamd3s"
)

install(DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/Yamd3s/"
    DESTINATION "${INSTALL_QMLDIR}/Yamd3s"
    FILES_MATCHING
    PATTERN "*.qml"
    PATTERN "qmldir"
    PATTERN "*.qmltypes"
)

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/shell.qml")
    install(FILES shell.qml DESTINATION "${INSTALL_QSCONFDIR}")
endif()