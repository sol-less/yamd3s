import Yamd3s
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.qml.services

PanelWindow {
    id: overlay

    property bool isActive: false

    visible: isActive
    color: Qt.alpha(Theme.md3.background, 0.85)
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayershell.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None // don't steal input, this is just visual feedback

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    Loading {
        active: overlay.isActive
        anchors.centerIn: parent
    }

    Behavior on color {
        ColorAnimation {
            duration: 250
        }

    }

}
