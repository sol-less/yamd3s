set_source_files_properties(Colors.qml Metrics.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(Y3sTokens
    URI "Y3s.Tokens"
    VERSION 1.0
    OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/imports/Y3s/Tokens"
    QML_FILES
        Colors.qml
        Corners.qml
        Metrics.qml
)
