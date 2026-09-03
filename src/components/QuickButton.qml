import Yamd3s
import QtQuick
import QtQuick.Controls.Basic

Button {
    id: control

    property bool isActive: false
    property bool isToggle: false

    text: ""
    implicitWidth: 36
    implicitHeight: 36

    // The text/icon inside the button
    contentItem: Text {
        text: control.text
        font.pixelSize: 18
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: control.isActive ? Theme.md3.on_primary : Theme.md3.on_surface

        Behavior on color {
            ColorAnimation {
                duration: 200
            }

        }

    }

    // The button shape and background
    background: Rectangle {
        radius: 12
        color: control.isActive ? Theme.md3.primary : Theme.md3.surface_container_high
        // Button natively provides the 'down' property when pressed
        scale: control.down ? 0.85 : 1

        Behavior on color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }

        }

        Behavior on scale {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutQuad
            }

        }

    }

}
