import QtQuick
import Quickshell
import Y3s.Globals
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
        if (!Config.hubComponents)
            return allTabs;

        return allTabs.filter((tab) => {
            return Config.hubComponents[tab.key] === true;
        });
    }

    signal startLockSequence()

    function setPanel(index) {
        activePanel = index;
    }

    function hubToggle() {
        if (hubActive || MatugenService.isRunning)
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
        // Safety check to ensure we don't select an out-of-bounds tab if one gets disabled
        if (root.visibleTabs.length > 0 && root.activePanel >= root.visibleTabs.length)
            root.activePanel = 0;

    }
}
