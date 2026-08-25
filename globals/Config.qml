import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

QtObject {
    id: root

    property var behavior: ({
        "bar": {
            "autoHide": true,
            "autoHideDelay": 300,
            "revealOnEdge": true
        },
        "panels": {
            "closeOnFocusLoss": true,
            "closeOnEscape": true,
            "animationEnabled": true
        }
    })
    property var barComponents: ({
        "workspaces": true,
        "clock": true,
        "volume": true,
        "brightness": true,
        "notifications": true,
        "power": true
    })
    property var hubComponents: ({
        "launcher": true,
        "wallpaper": true,
        "system": true,
        "music": true,
        "notifications": true
    })
    property var launcher: ({
        "type": "grid",
        "sortMode": "frequency",
        "showCategories": true,
        "showRecent": true,
        "launchOnEnter": true,
        "search": {
            "enabled": true,
            "placeholder": "Search applications...",
            "fuzzy": true
        }
    })
    property FileView behaviorFile

    behaviorFile: FileView {
        path: Quickshell.shellDir + "/config/behavior.json"
        watchChanges: true
        onFileChanged: reload()
        Component.onCompleted: reload()
        onLoaded: {
            try {
                const data = JSON.parse(text());
                root.behavior = Object.assign({
                }, root.behavior, data);
            } catch (e) {
                console.warn("Config.qml: Failed to parse behavior.json -> " + e);
            }
        }
    }

    property FileView componentsFile

    componentsFile: FileView {
        path: Quickshell.shellDir + "/config/components.json"
        watchChanges: true
        onFileChanged: reload()
        Component.onCompleted: reload()
        onLoaded: {
            try {
                const data = JSON.parse(text());
                if (data.bar)
                    root.barComponents = data.bar;

                if (data.hub)
                    root.hubComponents = data.hub;

            } catch (e) {
                console.warn("Config.qml: Failed to parse components.json -> " + e);
            }
        }
    }

    property FileView launcherFile

    launcherFile: FileView {
        path: Quickshell.shellDir + "/config/launcher.json"
        watchChanges: true
        onFileChanged: reload()
        Component.onCompleted: reload()
        onLoaded: {
            try {
                const data = JSON.parse(text());
                root.launcher = Object.assign({
                }, root.launcher, data);
            } catch (e) {
                console.warn("Config.qml: Failed to parse launcher.json -> " + e);
            }
        }
    }

}
