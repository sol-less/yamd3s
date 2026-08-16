//@ pragma DefaultEnv QS_NO_RELOAD_POPUP=1
import QtQuick
import Quickshell
import Quickshell.Io
import qs.bar
import qs.dashboard
import Y3s.Lib
import Y3s.Globals
import qs.services
import qs.lockscreen
import qs.settings

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData
            screen: modelData
        }
    }

    Dashboard {
        id: dashboard

        IpcHandler {
            target: "dashboard"
            function toggle(): void {
                States.dashboardToggle();
            }
            function open(): void {
                States.dashboardOpen();
            }
            function close(): void {
                States.dashboardClose();
            }
        }
    }

    IpcHandler {
        target: "lock"
        function lock(): void {
            States.requestLock();
        }
    }

    IpcHandler {
        target: "shell"
        function refresh(): void {
            Quickshell.reload(true)
        }
    }

    LoadingOverlay {
        isActive: MatugenService.isRunning
    }

    LockOverlay {}

    Settings {
        active: States.settingsOpen
    }
}
