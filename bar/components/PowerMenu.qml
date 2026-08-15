import M3Shapes
import QtQuick
import QtQuick.Layouts
import Y3s.Globals
import Y3s.Tokens

Item {
    width: rowLayout.width + 6
    height: parent.height - 12

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
                width: 28
                height: 28
                color: mouseHandler.containsMouse ? Colors.roleColor("powermenu", "container") : "transparent"
                scale: mouseHandler.containsMouse ? 1.2 : 1
                shape: MaterialShape.Cookie7Sided

                Text {
                    anchors.centerIn: parent
                    text: modelData.text
                    color: mouseHandler.containsMouse ? Colors.roleColor("powermenu", "on_container") : Colors.md3.on_surface_variant
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
