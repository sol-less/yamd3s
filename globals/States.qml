import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

QtObject {
    // i feel the screaming agony in my veins
    id: root

    readonly property string userConfigPath: Quickshell.shellDir + "/config/user_config.json"
    // ---- state properties ----
    property bool dashboardActive: false
    property int active_panel: 0
    property int currentSettingTab: 0
    property bool lockscreenActive: false
    property bool settingsOpen: false
    readonly property var settingTabs: [{
        "label": "General",
        "icon": ""
    }, {
        "label": "Appearance",
        "icon": ""
    }, {
        "label": "Dashboard Tabs",
        "icon": ""
    }]
    property var dashboardActiveTabs: ({
        "wallpaper": true,
        "system": true,
        "music": true
    })
    readonly property var allTabs: [{
        "key": "apps",
        "icon": "\ue5c3",
        "label": "Apps",
        "alwaysOn": true
    }, {
        "key": "wallpaper",
        "icon": "\ue3f4",
        "label": "Wallpaper"
    }, {
        "key": "system",
        "icon": "\ue30a",
        "label": "System"
    }, {
        "key": "music",
        "icon": "\ue405",
        "label": "Music"
    }]
    readonly property var visibleTabs: allTabs.filter((t) => {
        return t.alwaysOn || dashboardActiveTabs[t.key];
    })
    // ---- file handler property ----
    property FileView activeTabsFile

    activeTabsFile: FileView {
        id: activeTabsFile

        path: root.userConfigPath
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            try {
                const data = JSON.parse(text());
                if (data.activated_tabs)
                    root.dashboardActiveTabs = data.activated_tabs;

            } catch (e) {
                console.warn("States.qml: cannot parse user_config.json, using defaults");
            }
        }
        onLoadFailed: (error) => {
            console.warn("States.qml: user_config.json not found (" + error + "), using defaults");
        }
    }

    // ---- connections / property handlers ----
    property Connections _visibleTabsConn

    _visibleTabsConn: Connections {
        function onVisibleTabsChanged() {
            if (root.active_panel >= root.visibleTabs.length)
                root.active_panel = 0;

        }

        target: root
    }

    signal startLockSequence()

    // ---- helper functions ----
    function set_panel(index) {
        active_panel = index;
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
        active_panel = 0;
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

    function setTabActive(tabKey, enabled) {
        const updated = Object.assign({
        }, dashboardActiveTabs);
        updated[tabKey] = enabled;
        dashboardActiveTabs = updated;
        saveActiveTabs();
    }

    function saveActiveTabs() {
        let fullConfig = {
        };
        try {
            fullConfig = JSON.parse(activeTabsFile.text());
        } catch (e) {
        }
        fullConfig.activated_tabs = root.dashboardActiveTabs;
        activeTabsFile.setText(JSON.stringify(fullConfig, null, 2));
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

}
