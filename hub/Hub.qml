import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Y3s.Tokens
import Y3s.Globals
import Y3s.Lib
import qs.hub
import qs.hub.panels

PanelWindow {
    id: hub

    property bool surfaceVisible: false
    readonly property string currentTabKey: States.visibleTabs[States.activePanel]?.key ?? "launcher"
    visible: surfaceVisible

    property real openProgress: 0
    
    readonly property real maxSurfaceWidth: (Metrics.panels?.maxWidth ?? 800) + 80
    readonly property real maxSurfaceHeight: (Metrics.panels?.maxHeight ?? 600) + 20

    implicitWidth: maxSurfaceWidth
    implicitHeight: maxSurfaceHeight

    Connections {
        target: States
        function onHubActiveChanged() {
            if (States.hubActive) {
                hub.surfaceVisible = true;
                openAnim.duration = Config.behavior.panels.animationEnabled ? 350 : 0;
                openAnim.start();
            } else {
                closeAnim.duration = Config.behavior.panels.animationEnabled ? 220 : 0;
                closeAnim.start();
            }
        }
    }

    SequentialAnimation {
        id: openAnim
        property int duration: 350
        NumberAnimation {
            target: hub
            property: "openProgress"
            to: 1
            duration: openAnim.duration
            easing.type: Easing.OutQuint
        }
        ScriptAction {
            script: focus_grab.active = true
        }
    }

    SequentialAnimation {
        id: closeAnim
        property int duration: 220
        ScriptAction {
            script: focus_grab.active = false
        }
        NumberAnimation {
            target: hub
            property: "openProgress"
            to: 0
            duration: closeAnim.duration
            easing.type: Easing.InQuad
        }
        ScriptAction {
            script: hub.surfaceVisible = false
        }
    }

    anchors {
        bottom: true
    }

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayershell.Overlay
    WlrLayershell.keyboardFocus: States.hubActive ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    HyprlandFocusGrab {
        id: focus_grab
        windows: [hub]

        onCleared: {
            if (States.hubActive && Config.behavior.panels.closeOnFocusLoss) {
                States.hubClose();
            }
        }
    }

    Item {
        id: revealWrapper
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        
        width: panelBody.width + 48
        height: panelBody.height * hub.openProgress
        clip: true

        Rectangle {
            id: panelBody
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            // Determine dimensions from Metrics and Loader
            readonly property real contentWidth: panelLoader.item?.implicitWidth ?? Metrics.panelWidth(hub.currentTabKey)
            readonly property real contentHeight: panelLoader.item?.implicitHeight ?? Metrics.panelHeight(hub.currentTabKey)
            
            // Constrain the target size so it never exceeds the maxSurface dimensions
            readonly property real targetWidth: Math.min(contentWidth, maxSurfaceWidth - 80)
            readonly property real targetHeight: Math.min(contentHeight + 48 + (Metrics.spacing.medium * 2), maxSurfaceHeight - 20)

            width: targetWidth
            height: targetHeight

            Behavior on width {
                SpringAnimation {
                    spring: 3.2; damping: 0.3; mass: 1; epsilon: 0.25
                }
            }
            Behavior on height {
                SpringAnimation {
                    spring: 3.2; damping: 0.3; mass: 1; epsilon: 0.25
                }
            }

            topLeftRadius: Metrics.radii.huge
            topRightRadius: Metrics.radii.huge
            color: Colors.md3.surface_container_low
            clip: false

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Metrics.spacing.medium
                spacing: Metrics.spacing.small

                Loader {
                    id: panelLoader
                    asynchronous: true
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    sourceComponent: {
                        switch (hub.currentTabKey) {
                        case "launcher": return appLauncherPanel;
                        case "wallpaper": return wallpaperPanel;
                        case "system": return systemInfoPanel;
                        case "music": return musicPanel;
                        case "notifications": return notificationPanel;
                        default: return appLauncherPanel;
                        }
                    }
                    onLoaded: {
                        item.opacity = 0;
                        item.y = 12;
                        if (Config.behavior.panels.animationEnabled) {
                            panelEnter.start();
                        } else {
                            item.opacity = 1;
                            item.y = 0;
                        }
                    }
                    SequentialAnimation {
                        id: panelEnter
                        ParallelAnimation {
                            NumberAnimation {
                                target: panelLoader.item; property: "opacity"; to: 1
                                duration: 220; easing.type: Easing.OutQuad
                            }
                            NumberAnimation {
                                target: panelLoader.item; property: "y"; to: 0
                                duration: 320; easing.type: Easing.OutQuad
                            }
                        }
                    }
                }
                Switcher {}
            }

            Component { id: appLauncherPanel; AppLauncher {} }
            Component { id: wallpaperPanel; Wallpaper {} }
            Component { id: systemInfoPanel; SysInfo {} }
            Component { id: musicPanel; Music {} }
            Component { id: notificationPanel; Notifications {} }
        }

        Corners {
            corner: 2
            r: Metrics.radii.huge
            fillColor: panelBody.color
            anchors.bottom: parent.bottom
            anchors.right: panelBody.left
            opacity: panelBody.opacity
            visible: panelBody.height > Metrics.radii.huge
        }
        Corners {
            corner: 3
            r: Metrics.radii.huge
            fillColor: panelBody.color
            anchors.bottom: parent.bottom
            anchors.left: panelBody.right
            opacity: panelBody.opacity
            visible: panelBody.height > Metrics.radii.huge
        }
    }
}
