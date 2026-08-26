import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Yamd3s.Core
import Yamd3s.Visual
import qs.qml.bar.components

PanelWindow {
    id: root

    property bool modulesActive: hoverHandler.hovered || clock.moduleIndex === 1 || workspaces.recentlyChanged
    property bool isHovered: ConfigManager.behavior.bar.autoHide ? (modulesActive || timerHandler.running) : true
    readonly property real visibleBarHeight: Math.max(0, (barContainer.y + barContainer.height) - 4)

    onModulesActiveChanged: {
        if (ConfigManager.behavior.bar.autoHide) {
            if (!modulesActive)
                timerHandler.restart();
            else
                timerHandler.stop();
        }
    }
    height: ConfigManager.layout.bar.height
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
        height: parent.height
        width: rowContainer.implicitWidth + 12
        color: Theme.md3.surface_container_low
        bottomLeftRadius: ConfigManager.layout.radii.small
        bottomRightRadius: ConfigManager.layout.radii.small
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

    Corner {
        corner: 3
        anchors.top: parent.top
        anchors.left: barContainer.right
        color: Theme.md3.surface_container_low
        width: ConfigManager.layout.radii.medium
        height: Math.min(ConfigManager.layout.radii.medium, root.visibleBarHeight)
    }

    Corner {
        corner: 2
        anchors.top: parent.top
        anchors.right: barContainer.left
        color: Theme.md3.surface_container_low
        width: ConfigManager.layout.radii.medium
        height: Math.min(ConfigManager.layout.radii.medium, root.visibleBarHeight)
    }

}
