//@ pragma DefaultEnv QS_NO_RELOAD_POPUP=1
import QtQuick
import Quickshell
import Quickshell.Io
import Yamd3s.Globals
import qs.qml.bar
import qs.qml.hub
import qs.qml.services
import qs.qml.lockscreen
import qs.qml.settings
import qs.qml.notifications

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
