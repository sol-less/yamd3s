set_source_files_properties(MatugenService.qml PowerActions.qml States.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(Y3sGlobals
    URI "Y3s.Globals"
    VERSION 1.0
    OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/imports/Y3s/Globals"
    QML_FILES
        MatugenService.qml
        PowerActions.qml
        States.qml
)
