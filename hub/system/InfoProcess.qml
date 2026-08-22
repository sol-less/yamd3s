import QtQuick
import Quickshell
import Quickshell.Io
import Y3s.Globals
import Y3s.Tokens
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
    property int pacmanCount: 0
    property int aurCount: 0
    property int flatpakCount: 0
    property var prevCpu: ({
        "idle": 0,
        "total": 0
    })

    function refresh() {
        cpuProc.running = true;
        diskProc.running = true;
        batteryProc.running = true;
        uptimeProc.running = true;
        pkgProc.running = true;
    }

    Timer {
        interval: 2000
        running: States.dashboardActive
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }

    // ---- CPU ----
    Process {
        id: cpuProc

        command: ["sh", "-c", "head -n1 /proc/stat"]

        stdout: SplitParser {
            onRead: (line) => {
                const parts = line.trim().split(/\s+/).slice(1).map(Number);
                const idle = parts[3] + parts[4];
                const total = parts.reduce((a, b) => {
                    return a + b;
                }, 0);
                const prev = root.prevCpu;
                const idleDelta = idle - prev.idle;
                const totalDelta = total - prev.total;
                if (totalDelta > 0)
                    root.cpuPercent = Math.round(100 * (1 - idleDelta / totalDelta));

                root.prevCpu = {
                    "idle": idle,
                    "total": total
                };
            }
        }

    }

    // ---- Disk ----
    Process {
        id: diskProc

        command: ["sh", "-c", "df -B1 / | tail -n1"]

        stdout: SplitParser {
            onRead: (line) => {
                const parts = line.trim().split(/\s+/);
                const used = Number(parts[2]);
                const total = Number(parts[1]);
                root.diskUsedGb = Math.round(used / 1e+09 * 10) / 10;
                root.diskTotalGb = Math.round(total / 1e+09 * 10) / 10;
                root.diskPercent = Math.round((used / total) * 100);
            }
        }

    }

    // ---- Battery ----
    Process {
        id: batteryProc

        command: ["sh", "-c", "cat /sys/class/power_supply/BAT0/capacity 2>/dev/null; cat /sys/class/power_supply/BAT0/status 2>/dev/null"]

        stdout: SplitParser {
            property int lineIndex: 0

            onRead: (line) => {
                if (lineIndex === 0)
                    root.batteryPercent = Number(line.trim());
                else
                    root.batteryState = line.trim();
                lineIndex = (lineIndex + 1) % 2;
            }
        }

    }

    // ---- Uptime ----
    Process {
        id: uptimeProc

        command: ["sh", "-c", "uptime -p"]

        stdout: SplitParser {
            onRead: (line) => {
                root.uptimeStr = line.trim().replace("up ", "");
            }
        }

    }

    // ---- Packages (pacman + AUR + flatpak) ----
    Process {
        id: pkgProc

        command: ["sh", "-c", "pacman -Qq --native | wc -l; pacman -Qq --foreign | wc -l; flatpak list 2>/dev/null | wc -l"]

        stdout: SplitParser {
            property int lineIndex: 0

            onRead: (line) => {
                const value = Number(line.trim()) || 0;
                if (lineIndex === 0)
                    root.pacmanCount = value;
                else if (lineIndex === 1)
                    root.aurCount = value;
                else
                    root.flatpakCount = value;
                lineIndex++;
            }
        }

    }

}
