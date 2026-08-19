import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

QtObject {
    id: root

    readonly property string userConfigPath: Quickshell.shellDir + "/config/user_config.json"
    property var activatedTabs: ({
        "wallpaper": true,
        "system": true,
        "music": true,
        "notifications": true
    })
    property var others: ({
        "autoHideBar": true,
        "launcherType": "list"
    })
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
    }, {
        "key": "notifications",
        "icon": "\ue7f4",
        "label": "Notifications"
    }]
    property FileView configFile

    function setTabActive(tabKey, enabled) {
        activatedTabs = Object.assign({
        }, activatedTabs, {
            [tabKey]: enabled
        });
        saveConfig();
    }

    function saveConfig() {
        let config = {
        };
        try {
            config = JSON.parse(configFile.text());
        } catch (e) {
        }
        config.activatedTabs = root.activatedTabs;
        config.others = root.others;
        configFile.setText(JSON.stringify(config, null, 2));
    }

    configFile: FileView {
        path: root.userConfigPath
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            try {
                const data = JSON.parse(text());
                if (data.activatedTabs)
                    root.activatedTabs = data.activatedTabs;

                if (data.others)
                    root.others = data.others;

            } catch (e) {
                console.warn("Config.qml: cannot parse user_config.json, using defaults");
            }
        }
    }

}
