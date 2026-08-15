import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

QtObject {
    // Keep default empty object on error

    id: root

    readonly property string userConfigPath: Quickshell.shellDir + "/config/user_config.json"
    property var dashboardActiveTabs: ({
        "wallpaper": true,
        "system": true,
        "music": true
    })
    // ---- Tab Definitions ----
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
    // ---- File Handler ----
    property FileView activeTabsFile

    // ---- Helper Methods ----
    function setTabActive(tabKey, enabled) {
        const updated = Object.assign({
        }, dashboardActiveTabs);
        updated[tabKey] = enabled;
        dashboardActiveTabs = updated;
        saveConfig();
    }

    function saveConfig() {
        let fullConfig = {
        };
        try {
            fullConfig = JSON.parse(activeTabsFile.text());
        } catch (e) {
        }
        fullConfig.activated_tabs = root.dashboardActiveTabs;
        activeTabsFile.setText(JSON.stringify(fullConfig, null, 2));
    }

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
                console.warn("Config.qml: cannot parse user_config.json, using defaults");
            }
        }
        onLoadFailed: (error) => {
            console.warn("Config.qml: user_config.json not found (" + error + "), using defaults");
        }
    }

}
