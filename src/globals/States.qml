import Yamd3s
import QtQuick
pragma Singleton

QtObject {
    id: root

    property bool hubActive: false
    property int activePanel: 0
    property int currentSettingTab: 0
    property bool lockscreenActive: false
    property bool settingsOpen: false
    property bool launcherOpen: false
    property int panelMaxWidth: 800
    property int panelMaxHeight: 600
    // WARNING: The icon MUST be the code point on Material Symbols
    readonly property var allTabs: [{
        "key": "wallpaper",
        "icon": "\ue3f4",
        "name": "Wallpaper"
    }, {
        "key": "system",
        "icon": "\uf3da",
        "name": "System"
    }, {
        "key": "music",
        "icon": "\ueb1a",
        "name": "Music"
    }, {
        "key": "notifications",
        "icon": "\ue7f4",
        "name": "Notifications"
    }]
    readonly property var visibleTabs: {
        let hubConfig = ConfigManager.components ? ConfigManager.components.hub : null;
        if (!hubConfig)
            return allTabs;

        return allTabs.filter((tab) => {
            return hubConfig[tab.key] === true;
        });
    }
    property Connections matugenConn

    matugenConn: Connections {
        function onIsRunningChanged() {
            if (MatugenService.isRunning) {
                root.hubClose();
                root.closeLauncher();
            }
        }

        target: MatugenService
    }

    signal startLockSequence()

    function setPanel(index) {
        activePanel = index;
    }

    function hubToggle() {
        if (hubActive)
            hubClose();
        else
            hubOpen();
    }

    function hubOpen() {
        if (MatugenService.isRunning || launcherOpen)
            return ;

        closeLauncher();
        hubActive = true;
    }

    function hubClose() {
        hubActive = false;
    }

    function toggleLauncher() {
        if (launcherOpen)
            closeLauncher();
        else
            openLauncher();
    }

    function openLauncher() {
        if (MatugenService.isRunning || hubActive) {
            return ;
        }
        launcherOpen = true;
    }

    function closeLauncher() {
        launcherOpen = false;
    }

    function toggleLock() {
        lockscreenActive = !lockscreenActive;
        if (lockscreenActive) {
            hubClose();
            closeLauncher();
        }
    }

    function requestLock() {
        hubClose();
        closeLauncher();
        startLockSequence();
    }

    function toggleSettings() {
        if (settingsOpen)
            closeSettings();
        else
            openSettings();
    }

    function openSettings() {
        settingsOpen = true;
        hubClose();
        closeLauncher();
    }

    function closeSettings() {
        settingsOpen = false;
    }

    onVisibleTabsChanged: {
        if (root.visibleTabs.length > 0 && root.activePanel >= root.visibleTabs.length)
            root.activePanel = 0;

    }
}
