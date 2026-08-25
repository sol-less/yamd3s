//@ pragma DefaultEnv QS_NO_RELOAD_POPUP=1
import QtQuick
import Quickshell
import Quickshell.Io
import qs.bar
import qs.hub
import Y3s.Globals
import qs.services
import qs.lockscreen
import qs.settings
import qs.notifications

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData
            screen: modelData
        }
    }

    Variants {
        model: Quickshell.screens
        LoadingOverlay {
            required property var modelData
            screen: modelData
            isActive: MatugenService.isRunning
        }
    }

    Hub {
        id: hub

        IpcHandler {
            target: "hub"
            function toggle(): void {
                States.hubToggle();
            }
            function open(): void {
                States.hubOpen();
            }
            function close(): void {
                States.hubClose();
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

    NotifDisplay {}

    LockOverlay {}

    Settings {
        active: States.settingsOpen
    }
}
