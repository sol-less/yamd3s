import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Yamd3s.Globals
import Yamd3s.Visual
import Yamd3s.Core
import qs.qml.hub
import qs.qml.hub.panels

PanelWindow {
    id: hub

    property bool surfaceVisible: false
    readonly property string currentTabKey: States.visibleTabs[States.activePanel]?.key ?? "launcher"
    visible: surfaceVisible

    property real openProgress: 0
    
    readonly property real maxSurfaceWidth: (ConfigManager.panels?.max?.width ?? 800) + 80
    readonly property real maxSurfaceHeight: (ConfigManager.panels?.max?.height ?? 600) + 20

    function getPanelWidth(name) {
        if (ConfigManager.panels && ConfigManager.panels[name])
            return ConfigManager.panels[name].width ?? 400;
        return 400;
    }

    function getPanelHeight(name) {
        if (ConfigManager.panels && ConfigManager.panels[name])
            return ConfigManager.panels[name].height ?? 400;
        return 400;
    }

    implicitWidth: maxSurfaceWidth
    implicitHeight: maxSurfaceHeight

    Connections {
        target: States
        function onHubActiveChanged() {
            if (States.hubActive) {
                hub.surfaceVisible = true;
                openAnim.duration = ConfigManager.behavior?.panels?.animationEnabled ? 350 : 0;
                openAnim.start();
            } else {
                closeAnim.duration = ConfigManager.behavior?.panels?.animationEnabled ? 220 : 0;
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

        onCleared: {
            if (States.hubActive) {
                States.hubClose()
            }
        }
    } 

    Item {
        id: revealWrapper
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        
        width: panelBody.width + (ConfigManager.layout.radii.huge * 2)
        height: panelBody.height * hub.openProgress
        clip: true

        readonly property real visiblePanelHeight: Math.max(0, panelBody.height - panelBody.y)

        Rectangle {
            id: panelBody
            anchors.horizontalCenter: parent.horizontalCenter

            y: (1 - hub.openProgress) * height

            // Determine dimensions locally via ConfigManager
            readonly property real contentWidth: panelLoader.item?.implicitWidth ?? hub.getPanelWidth(hub.currentTabKey)
            readonly property real contentHeight: panelLoader.item?.implicitHeight ?? hub.getPanelHeight(hub.currentTabKey)
            
            // Constrain target size relative to maxSurface
            readonly property real targetWidth: Math.min(contentWidth, maxSurfaceWidth - 80)
            readonly property real targetHeight: Math.min(contentHeight + 48 + (ConfigManager.layout.spacing.medium * 2), maxSurfaceHeight - 20)

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

            topLeftRadius: ConfigManager.layout.radii.huge
            topRightRadius: ConfigManager.layout.radii.huge
            color: Theme.md3.surface_container_low
            clip: false

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: ConfigManager.layout.spacing.medium
                spacing: ConfigManager.layout.spacing.small

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
                        if (ConfigManager.behavior?.panels?.animationEnabled) {
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

        // Bottom-Left Concave Fillet
        Corner {
            id: leftCorner
            corner: 1
            color: panelBody.color

            width: ConfigManager.layout.radii.huge
            height: ConfigManager.layout.radii.huge * hub.openProgress

            targetWidth: panelBody.width
            targetHeight: panelBody.height

            anchors.bottom: parent.bottom
            anchors.right: panelBody.left
        }

        // Bottom-Right Concave Fillet
        Corner {
            id: rightCorner
            corner: 0
            color: panelBody.color

            width: ConfigManager.layout.radii.huge
            height: ConfigManager.layout.radii.huge * hub.openProgress

            targetWidth: panelBody.width
            targetHeight: panelBody.height

            anchors.bottom: parent.bottom
            anchors.left: panelBody.right
        }
    }
}