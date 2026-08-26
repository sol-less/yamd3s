import QtQuick
import Quickshell
import Quickshell.Io
import Yamd3s.Globals
pragma Singleton

QtObject {
    // FIX : regretting my whole life decisions on this shit
    // Fixed typo (was is_running)

    id: root

    property bool isRunning: false
    property bool _process_done: false
    property var current_wallpaper: ""
    // ---- child objects declared as properties ----
    property Timer minDurationTimer
    property Process matugenProc

    signal wallpaperApplied(string path)

    // ---- helper functions ----
    function applyWallpaper(path) {
        matugenProc.command = ["matugen", "image", path, "--source-color-index", "0"];
        isRunning = true;
        matugenProc.running = true;
        root.wallpaperApplied(path);
    }

    minDurationTimer: Timer {
        id: min_duration_timer

        interval: 700
        onTriggered: {
            root._process_done = true;
            if (!matugenProc.running)
                root.isRunning = false;

        }
    }

    matugenProc: Process {
        id: matugenProc

        onExited: (code, status) => {
            root.isRunning = false;
        }
    }

}
