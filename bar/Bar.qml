import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Y3s.Config
import Y3s.Lib
import Y3s.Tokens
import qs.bar.components

PanelWindow {
    id: root

    property bool modulesActive: hoverHandler.hovered || clock.moduleIndex === 1 || workspaces.recentlyChanged
    property bool isHovered: ConfigManager.behavior.bar.autoHide ? (modulesActive || timerHandler.running) : true

    onModulesActiveChanged: {
        if (ConfigManager.behavior.bar.autoHide) {
            if (!modulesActive)
                timerHandler.restart();
            else
                timerHandler.stop();
        }
    }
    height: Metrics.bar.height
    color: "transparent"
    WlrLayershell.exclusiveZone: ConfigManager.behavior.bar.autoHide ? height - 24 : ConfigManager.layout.bar.height

    anchors {
        top: true
        left: true
        right: true
    }

    Timer {
        id: timerHandler

        running: false
        interval: ConfigManager.behavior.bar.autoHideDelay
    }

    Rectangle {
        id: barContainer

        anchors.horizontalCenter: parent.horizontalCenter
        height: Metrics.bar.height
        width: rowContainer.implicitWidth + 12
        color: Theme.md3.surface_container_low
        bottomLeftRadius: root.isHovered ? 12 : 10
        bottomRightRadius: root.isHovered ? 12 : 10
        y: root.isHovered ? 0 : -height + 16
        clip: true

        RowLayout {
            id: rowContainer

            anchors.centerIn: parent
            spacing: 12

            Workspaces {
                id: workspaces

                Layout.alignment: Qt.AlignVCenter
                opacity: root.isHovered ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.OutQuad
                    }

                }

            }

            Item {
                Layout.alignment: Qt.AlignVCenter
                Layout.fillHeight: true
                Layout.preferredWidth: clock.width
                opacity: root.isHovered ? 1 : 0

                Clock {
                    id: clock

                    height: barContainer.height - 12
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.OutQuad
                    }

                }

            }

            PowerMenu {
                Layout.alignment: Qt.AlignVCenter
                opacity: root.isHovered ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.OutQuad
                    }

                }

            }

        }

        HoverHandler {
            id: hoverHandler
        }

        Behavior on y {
            NumberAnimation {
                duration: 350
                easing.type: Easing.OutQuad
            }

        }

    }

    Corners {
        r: 12
        corner: 0
        anchors.top: parent.top
        anchors.left: barContainer.right
        fillColor: barContainer.color
    }

    Corners {
        r: 12
        corner: 1
        anchors.top: parent.top
        anchors.right: barContainer.left
        fillColor: barContainer.color
    }

}
