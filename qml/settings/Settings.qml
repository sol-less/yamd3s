import M3Shapes
import QtQuick
import QtQuick.Layouts
import Quickshell
import Yamd3s.Globals

import qs.qml.settings.components

FloatingWindow {
    id: root

    property bool active: false

    visible: active
    minimumSize: Qt.size(860, 500)
    maximumSize: minimumSize
    title: "Quickshell Settings"
    color: Theme.md3.surface_container

    MaterialShape {
        shape: mouseHandler.containsMouse ? MaterialShape.Cookie4Sided : MaterialShape.Circle
        implicitSize: 40
        anchors.margins: 10
        anchors.top: parent.top
        anchors.right: parent.right
        color: Theme.md3.primary

        MouseArea {
            id: mouseHandler

            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                States.closeSettings();
            }
        }

    }

    RowLayout {
        anchors.fill: parent
        spacing: 16
        anchors.margins: 20

        ColumnLayout {
            Layout.fillHeight: true
            spacing: 8

            Text {
                Layout.preferredWidth: 200
                Layout.preferredHeight: 40
                text: "Settings"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 13
                font.family: "Google Sans"
                color: Theme.md3.on_surface_variant
            }

            Repeater {
                model: States.settingTabs

                delegate: TabsButton {
                    width: 200
                    height: 44
                    onClicked: States.currentSettingTab = index
                }

            }

            Item {
                Layout.fillHeight: true
            }

        }

        Rectangle {
            Layout.fillHeight: true
            width: 1
            color: Theme.md3.outline
        }

        Item {
            Layout.fillWidth: true
        }

    }

}
