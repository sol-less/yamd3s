import QtQuick
import Yamd3s.Core // Pull in the C++ ConfigManager
pragma Singleton

QtObject {
    id: root

    property bool hubActive: false
    property int activePanel: 0
    property int currentSettingTab: 0
    property bool lockscreenActive: false
    property bool settingsOpen: false
    
    property int panelMaxWidth: 800
    property int panelMaxHeight: 600
    
    // WARNING: The icon MUST be the code point on Material Symbols
    readonly property var allTabs: [{
        "key": "launcher",
        "icon": "\ueb9b",
        "name": "Apps"
    }, {
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
        // Use ConfigManager.components instead of Config.hubComponents
        let hubConfig = ConfigManager.components ? ConfigManager.components.hub : null;
        if (!hubConfig) return allTabs;

        return allTabs.filter((tab) => {
            return hubConfig[tab.key] === true;
        });
    }

    signal startLockSequence()

    function setPanel(index) {
        activePanel = index;
    }

    // (UI logic remains exactly the same below)
    
    function hubToggle() {
        // If you still have a MatugenService QML file somewhere, make sure it's valid.
        // Otherwise, replace MatugenService.isRunning with whatever tracks theme gen state.
        if (hubActive)
            hubClose();
        else
            hubOpen();
    }

    function hubOpen() {
        hubActive = true;
    }

    function hubClose() {
        hubActive = false;
    }

    function toggleLock() {
        lockscreenActive = !lockscreenActive;
        if (lockscreenActive)
            hubClose();
    }

    function requestLock() {
        hubClose();
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
        hubActive = false;
    }

    function closeSettings() {
        settingsOpen = false;
    }

    onVisibleTabsChanged: {
        if (root.visibleTabs.length > 0 && root.activePanel >= root.visibleTabs.length)
            root.activePanel = 0;
    }
}