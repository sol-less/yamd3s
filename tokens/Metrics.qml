pragma Singleton
import Quickshell

Singleton {
    readonly property int bar_margin_top: 8
    readonly property int bar_height: 40
    readonly property int launcher_gap: 10

    readonly property int launcher_margin_top: bar_margin_top + bar_height + launcher_gap

    readonly property var panelSizes: ({
            apps: {
                width: 530,
                height: 500
            },
            wallpaper: {
                width: 700,
                height: 420
            },
            system: {
                width: 575,
                height: 245
            },
            music: {
                width: 570,
                height: 225
            }
        })

    readonly property real panelMaxWidth: 640
    readonly property real panelMaxHeight: 640
    readonly property real panelMinWidth: 320
    readonly property real panelMinHeight: 200
    readonly property real switcherReserve: 90
}
