import Yamd3s
import M3Shapes
import QtQuick
import QtQuick.Controls.Basic


Switch {
    id: control

    property int trackWidth: 52
    property int trackHeight: 32
    property var contentText: "hi"
    property int margin: 4

    hoverEnabled: true

    indicator: Rectangle {
        implicitWidth:  control.trackWidth
        implicitHeight: control.trackHeight
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: height / 2
        color: control.checked ? Theme.roleColor("notificationButton") : Theme.md3.surface_container_highest
        border.color: control.checked ? Theme.roleColor("notificationButton") : Theme.md3.outline
        border.width: 2

        MaterialShape {
            id: thumb

            implicitSize: 20
            shape: control.checked ? MaterialShape.Sunny : MaterialShape.Circle
            x: control.checked ? (parent.width - width - control.margin) : (control.margin + (24 - width) / 2)
            y: parent.height / 2 - height / 2
            color: control.checked ? Theme.roleColor("notificationButton", "on") : Theme.md3.outline

            Text {
                text: "\ue5ca"
                font.family: "Material Symbols Rounded"
                font.pixelSize: 16
                anchors.centerIn: parent
                color: Theme.roleColor("notificationButton", "onContainer")
                opacity: control.checked ? 1 : 0
                scale: control.checked ? 1 : 0.5

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }

                }

                Behavior on scale {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutBack
                    }

                }

            }

            Behavior on x {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutBack
                }

            }

            Behavior on width {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutBack
                }

            }

            Behavior on height {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutBack
                }

            }

            Behavior on color {
                ColorAnimation {
                    duration: 250
                    easing.type: Easing.OutBack
                }

            }

        }

        Behavior on color {
            ColorAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }

        }

        Behavior on border.color {
            ColorAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }

        }

    }

    contentItem: Text {
        text: control.contentText
        font.family: "Google Sans"
        font.pixelSize: 14
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
        color: control.checked ? Theme.roleColor("notificationButton") : Theme.md3.outline

        Behavior on color {
            ColorAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }

        }

    }

}
