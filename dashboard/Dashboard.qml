import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Y3s.Tokens
import Y3s.Globals
import Y3s.Lib
import qs.dashboard
import qs.dashboard.panels
import qs.dashboard.system

PanelWindow {
    id: dashboard

    property bool surfaceVisible: false
    readonly property string currentTabKey: States.visibleTabs[States.activePanel]?.key ?? "apps"
    visible: surfaceVisible

    property real openProgress: 0
    readonly property real fullHeight: 560

    Connections {
        target: States
        function onDashboardActiveChanged() {
            if (States.dashboardActive) {
                dashboard.surfaceVisible = true;
                openAnim.start();
            } else {
                closeAnim.start();
            }
        }
    }

    SequentialAnimation {
        id: openAnim
        NumberAnimation {
            target: dashboard
            property: "openProgress"
            to: 1
            duration: 350
            easing.type: Easing.OutQuint
        }
        ScriptAction {
            script: focus_grab.active = true
        }
    }

    SequentialAnimation {
        id: closeAnim
        ScriptAction {
            script: focus_grab.active = false
        }
        NumberAnimation {
            target: dashboard
            property: "openProgress"
            to: 0
            duration: 220
            easing.type: Easing.InQuad
        }
        ScriptAction {
            script: dashboard.surfaceVisible = false
        }
    }

    anchors {
        bottom: true
    }

    color: "transparent"
    implicitWidth: Metrics.panelMaxWidth + 80
    implicitHeight: Metrics.panelMaxHeight
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayershell.Overlay
    WlrLayershell.keyboardFocus: States.dashboardOpen ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    HyprlandFocusGrab {
        id: focus_grab
        windows: [dashboard]

        onCleared: {
            if (States.dashboardActive && appLauncherPanel.notFocus === true ) {
                States.dashboardClose();
            }
        }
    }

    Item {
        id: revealWrapper
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: panelBody.width + 48
        height: panelBody.height * dashboard.openProgress
        clip: true

        Rectangle {
            id: panelBody
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            readonly property real contentWidth: panelLoader.item?.implicitWidth ?? Metrics.panelSizes.apps.width
            readonly property real contentHeight: panelLoader.item?.implicitHeight ?? Metrics.panelSizes.apps.height
            readonly property real targetWidth: Math.min(Math.max(contentWidth, Metrics.panelMinWidth), dashboard.width - 80)
            readonly property real targetHeight: Math.min(Math.max(contentHeight + Metrics.switcherReserve, Metrics.panelMinHeight), dashboard.height - 16)
            width: targetWidth
            height: targetHeight

            Behavior on width {
                SpringAnimation {
                    spring: 3.2
                    damping: 0.3
                    mass: 1
                    epsilon: 0.25
                }
            }
            Behavior on height {
                SpringAnimation {
                    spring: 3.2
                    damping: 0.3
                    mass: 1
                    epsilon: 0.25
                }
            }

            topLeftRadius: 24
            topRightRadius: 24
            color: Colors.md3.surface_container_low
            clip: false

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                Loader {
                    id: panelLoader
                    asynchronous: true
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    sourceComponent: {
                        switch (dashboard.currentTabKey) {
                        case "apps":
                            return appLauncherPanel;
                        case "wallpaper":
                            return wallpaperPanel;
                        case "system":
                            return systemInfoPanel;
                        case "music":
                            return musicPanel;
                        case "notifications":
                            return notificationPanel
                        default:
                            return appLauncherPanel;
                        }
                    }
                    onLoaded: {
                        item.opacity = 0;
                        item.y = 12;
                        panelEnter.start();
                    }
                    SequentialAnimation {
                        id: panelEnter
                        ParallelAnimation {
                            NumberAnimation {
                                target: panelLoader.item
                                property: "opacity"
                                to: 1
                                duration: 220
                                easing.type: Easing.OutQuad
                            }
                            NumberAnimation {
                                target: panelLoader.item
                                property: "y"
                                to: 0
                                duration: 320
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                }
                Switcher {}
            }

            Component {
                id: appLauncherPanel
                AppLauncher {
                }
            }
            Component {
                id: wallpaperPanel
                Wallpaper {}
            }
            Component {
                id: systemInfoPanel
                SysInfo {}
            }
            Component {
                id: musicPanel
                Music {}
            }
            Component {
                id: notificationPanel
                Notifications {}
            }
        }

        Corners {
            corner: 2
            r: 24
            fillColor: panelBody.color
            anchors.bottom: panelBody.bottom
            anchors.right: panelBody.left
            opacity: panelBody.opacity
        }
        Corners {
            corner: 3
            r: 24
            fillColor: panelBody.color
            anchors.bottom: panelBody.bottom
            anchors.left: panelBody.right
            opacity: panelBody.opacity
        }
    }
}
