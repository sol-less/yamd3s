import Yamd3s
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.qml.shell.bar.components
import qs.qml.shell.bar.components.launcher

PanelWindow {
    id: root

    property bool isLauncher: States.launcherOpen
    property bool isTransitioning: false
    property bool modulesActive: hoverHandler.hovered || clock.moduleIndex === 1 || workspaces.recentlyChanged
    property bool isHovered: (ConfigManager.vanilla["behavior.bar.autoHide"] ? (modulesActive || timerHandler.running) : true) || isLauncher
    readonly property real visibleBarHeight: Math.max(0, (barContainer.y + barContainer.height) - 4)

    onIsLauncherChanged: {
        isTransitioning = true;
        launcherTransitionTimer.restart();
    }
    onModulesActiveChanged: {
        if (ConfigManager.vanilla["behavior.bar.autoHide"]) {
            if (!modulesActive)
                timerHandler.restart();
            else
                timerHandler.stop();
        }
    }
    implicitHeight: ConfigManager.vanilla["panels.apps.height"]
    color: "transparent"
    WlrLayershell.exclusiveZone: ConfigManager.vanilla["behavior.bar.autoHide"] ? Math.round(ConfigManager.vanilla["layout.bar.height"] / 2) : Math.round(ConfigManager.vanilla["layout.bar.height"])
    WlrLayershell.keyboardFocus: root.isLauncher ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    anchors {
        top: true
        left: true
        right: true
    }

    Shortcut {
        sequence: "Escape"
        enabled: root.isLauncher
        onActivated: {
            States.closeLauncher();
        }
    }

    Timer {
        id: launcherTransitionTimer

        interval: 350
        onTriggered: root.isTransitioning = false
    }

    Timer {
        id: timerHandler

        running: false
        interval: ConfigManager.vanilla["behavior.bar.autoHideDelay"]
    }

    HyprlandFocusGrab {
        onCleared: {
            States.closeLauncher();
        }
    }

    Rectangle {
        id: barContainer

        anchors.horizontalCenter: parent.horizontalCenter
        height: root.isLauncher ? ConfigManager.vanilla["panels.apps.height"] : ConfigManager.vanilla["layout.bar.height"]
        width: root.isLauncher ? ConfigManager.vanilla["panels.apps.width"] : rowContainer.implicitWidth + 12
        color: Theme.md3.surface_container_low
        bottomLeftRadius: ConfigManager.vanilla["layout.radii.small"]
        bottomRightRadius: ConfigManager.vanilla["layout.radii.small"]
        y: root.isHovered ? 0 : -height + 16
        clip: true

        RowLayout {
            id: rowContainer

            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12
            height: ConfigManager.vanilla["layout.bar.height"]
            opacity: root.isLauncher ? 0 : 1
            visible: opacity > 0.3

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
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: clock.width
                opacity: root.isHovered ? 1 : 0

                Clock {
                    id: clock

                    height: ConfigManager.vanilla["layout.bar.height"] - 12
                    anchors.centerIn: parent
                    onLauncherOpen: {
                        States.toggleLauncher();
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 220
                        easing.type: Easing.OutQuad
                    }

                }

            }

            PowerMenu {
                Layout.alignment: Qt.AlignVCenter
                opacity: root.isHovered ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 220
                        easing.type: Easing.OutQuad
                    }

                }

            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutQuad
                }

            }

        }

        Item {
            id: launcherContainer

            anchors.fill: parent
            opacity: root.isLauncher ? 1 : 0
            visible: opacity > 0

            ColumnLayout {
                id: column

                property bool notFocus: searchBar.text.length === 0
                property bool isGridMode: ConfigManager.vanilla["components.launcher.mode"] === "grid"
                property var allApps: DesktopEntries.applications.values
                property var filteredApps: {
                    const query = searchBar.text.toLowerCase();
                    if (query.length === 0)
                        return allApps;

                    return allApps.filter((app) => {
                        return app.name.toLowerCase().includes(query);
                    });
                }

                function activateApp(app) {
                    app.execute();
                    States.closeLauncher();
                }

                anchors.centerIn: parent
                anchors.margins: 6
                anchors.fill: parent

                Search {
                    id: searchBar

                    onConfirm: {
                        if (appList.appRefCurrent)
                            column.activateApp(appList.appRefCurrent);

                    }
                }

                AppList {
                    id: appList

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    model: column.filteredApps
                    gridMode: column.isGridMode
                    onAppActivated: (a) => {
                        return column.activateApp(a);
                    }
                }

            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutQuad
                }

            }

        }

        HoverHandler {
            id: hoverHandler
        }

        Behavior on width {
            enabled: root.isTransitioning

            SpringAnimation {
                spring: 3.2
                damping: 0.3
                mass: 1
                epsilon: 0.25
            }

        }

        Behavior on height {
            enabled: root.isTransitioning

            SpringAnimation {
                spring: 3.2
                damping: 0.3
                mass: 1
                epsilon: 0.25
            }

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
        implicitWidth: ConfigManager.vanilla["layout.radii.huge"]
        implicitHeight: Math.min(ConfigManager.vanilla["layout.radii.huge"], root.visibleBarHeight)
    }

    Corner {
        corner: 2
        anchors.top: parent.top
        anchors.right: barContainer.left
        color: Theme.md3.surface_container_low
        implicitWidth: ConfigManager.vanilla["layout.radii.huge"]
        implicitHeight: Math.min(ConfigManager.vanilla["layout.radii.huge"], root.visibleBarHeight)
    }

    mask: Region {
        item: barContainer
    }

}
