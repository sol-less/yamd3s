import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

QtObject {
    id: root

    readonly property string userConfigPath: Quickshell.shellDir + "/config/metrics.json"
    readonly property int barMarginTop: 8
    readonly property int barHeight: 40
    readonly property int launcherGap: 10
    readonly property int launcherMarginTop: barMarginTop + barHeight + launcherGap
    readonly property real panelMaxWidth: 900
    readonly property real panelMaxHeight: 640
    readonly property real panelMinWidth: 320
    readonly property real panelMinHeight: 200
    readonly property real switcherReserve: 90
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
        },
        "notifications": {
            "width": 200,
            "height": 150
        }
    })
    property FileView panelSizeFile

    panelSizeFile: FileView {
        path: root.userConfigPath
        watchChanges: true
        onFileChanged: reload()
        Component.onCompleted: reload()
        onLoaded: {
            try {
                const data = JSON.parse(text());
                if (data.panelSizes)
                    root.panelSizes = data.panelSizes;

            } catch (e) {
                console.warn("Metrics.qml: Error parsing JSON: " + e);
            }
        }
    }

}
