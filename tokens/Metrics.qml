import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

QtObject {
    id: root

    readonly property string userConfigPath: Quickshell.shellDir + "/config/user_config.json"
    readonly property int bar_margin_top: 8
    readonly property int bar_height: 40
    readonly property int launcher_gap: 10
    readonly property int launcher_margin_top: bar_margin_top + bar_height + launcher_gap
    property var panelSizes: ({
        "apps": {
            "width": 900,
            "height": 500
        },
        "wallpaper": {
            "width": 700,
            "height": 420
        },
        "system": {
            "width": 755,
            "height": 245
        },
        "music": {
            "width": 570,
            "height": 225
        }
    })
    readonly property real panelMaxWidth: 900
    readonly property real panelMaxHeight: 640
    readonly property real panelMinWidth: 320
    readonly property real panelMinHeight: 200
    readonly property real switcherReserve: 90
    property FileView panelSize

    panelSize: FileView {
        id: panelSize

        path: userConfigPath
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            try {
                const data = JSON.parse(text());
                if (data.panel_sizes)
                    root.panelSizes = data.panel_sizes;

            } catch (e) {
                console.warn("Metrics.qml: Error to parse JSON: " + e);
            }
        }
        onLoadFailed: {
            console.warn("Metrics.qml: Failed to parse JSON");
        }
    }

}
