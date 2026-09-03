import M3Shapes
import QtQuick
import QtQuick.Layouts
import Yamd3s

Item {
    implicitWidth: rowLayout.width + 6
    implicitHeight: parent.height - 12

    RowLayout {
        id: rowLayout

        anchors.centerIn: parent
        spacing: 16

        Repeater {
            model: [{
                "text": "\ue8ac",
                "action": PowerActions.shutdown
            }, {
                "text": "\uf053",
                "action": PowerActions.reboot
            }, {
                "text": "\ue897",
                "action": PowerActions.lock
            }]

            delegate: MaterialShape {
                implicitWidth: 28
                implicitHeight: 28
                color: mouseHandler.containsMouse ? Theme.roleColor("powermenu", "container") : "transparent"
                scale: mouseHandler.containsMouse ? 1.2 : 1
                shape: MaterialShape.Cookie7Sided

                Text {
                    anchors.centerIn: parent
                    text: modelData.text
                    color: mouseHandler.containsMouse ? Theme.roleColor("powermenu", "on_container") : Theme.md3.on_surface_variant
                    font.family: "Material Symbols Rounded"

                    Behavior on color {
                        ColorAnimation {
                            duration: 250
                        }

                    }

                }

                MouseArea {
                    id: mouseHandler

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: modelData.action()
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 250
                    }

                }

                Behavior on scale {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutQuad
                    }

                }

            }

        }

    }

}
