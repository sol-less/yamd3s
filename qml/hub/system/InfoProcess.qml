import QtQuick
import Quickshell
import Quickshell.Io
import Yamd3s.Globals

pragma Singleton

Singleton {
    id: root

    property real cpuPercent: 0
    property real diskPercent: 0
    property real diskUsedGb: 0
    property real diskTotalGb: 0
    property int batteryPercent: 0
    property string batteryState: "unknown"
    property string uptimeStr: "linux"
    property int packagesCount: 0

    Process {
        id: pyProc

        running: States.hubActive
        command: ["python3", Qt.resolvedUrl("../../assets/sysinfo.py").toString().replace("file://", "")]

        stdout: SplitParser {
            onRead: (line) => {
                if (!line)
                    return ;

                try {
                    const data = JSON.parse(line.trim());
                    root.cpuPercent = data.cpuPercent;
                    root.diskPercent = data.diskPercent;
                    root.diskUsedGb = data.diskUsedGb;
                    root.diskTotalGb = data.diskTotalGb;
                    root.batteryPercent = data.batteryPercent;
                    root.batteryState = data.batteryState;
                    root.uptimeStr = data.uptimeStr;
                    // Update universal package count
                    root.packagesCount = data.packagesCount;
                } catch (err) {
                    console.log("Error parsing Python sysinfo: " + err);
                }
            }
        }

    }

}
