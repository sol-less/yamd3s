import QtQuick
import Quickshell
import Y3s.Globals
pragma Singleton

QtObject {
    id: root

    // ---- UI State Properties ----
    property bool dashboardActive: false
    property int activePanel: 0
    property int currentSettingTab: 0
    property bool lockscreenActive: false
    property bool settingsOpen: false
    // Derived from Config singleton
    readonly property var visibleTabs: Config.allTabs.filter((t) => {
        return t.alwaysOn || Config.activatedTabs[t.key];
    })

    signal startLockSequence()

    // ---- Helper Functions ----
    function setPanel(index) {
        activePanel = index;
    }

    function dashboardToggle() {
        if (dashboardActive)
            dashboardClose();
        else
            dashboardOpen();
    }

    function dashboardOpen() {
        dashboardActive = true;
    }

    function dashboardClose() {
        dashboardActive = false;
        activePanel = 0;
    }

    function toggleLock() {
        lockscreenActive = !lockscreenActive;
        if (lockscreenActive)
            dashboardClose();

    }

    function requestLock() {
        dashboardClose();
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
        dashboardActive = false;
    }

    function closeSettings() {
        settingsOpen = false;
    }

    // Bound guard check: keep panel within visible range when tabs are toggled off
    onVisibleTabsChanged: {
        if (root.activePanel >= root.visibleTabs.length)
            root.activePanel = 0;

    }
}
