qt_add_qml_module(Y3sLib
    URI "Y3s.Lib"
    VERSION 1.0
    OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/imports/Y3s/Lib"
    QML_FILES
        Slider.qml
        Progress.qml
        RangeSlider.qml
    DEPENDENCIES
        Y3sTokens
        Y3sGlobals
)
