import QtQuick
import Quickshell
import Quickshell.Wayland
import Y3s.Tokens
import qs.services

PanelWindow {
    id: root

    property var alphaCount: 0
    property var baseAnimLength: 1
    property var animLength: (baseAnimLength * 1000) / 2

    signal animStart()
    signal animStopped()

    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayershell.Overlay
    color: Qt.alpha(Colors.md3.background, alphaCount)
    visible: false
    onAnimStart: animation.start()

    anchors {
        top: true
        left: true
        bottom: true
        right: true
    }

    Rectangle {
        id: animTarget

        anchors.centerIn: parent
        width: 100
        height: 100
        color: "transparent"

        Loading {
            anchors.fill: parent
            anchors.margins: 10
            active: animation.running
        }

    }

    SequentialAnimation {
        id: animation

        onFinished: {
            root.animStopped();
            root.visible = false;
            root.alphaCount = 0;
        }

        ScriptAction {
            script: {
                root.visible = true;
            }
        }

        NumberAnimation {
            target: root
            property: "alphaCount"
            to: 1
            duration: root.animLength
        }

        PauseAnimation {
            duration: root.animLength
        }

    }

}
