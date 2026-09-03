//@ pragma DefaultEnv QS_NO_RELOAD_POPUP=1
import QtQuick
import Quickshell
import Quickshell.Io
import Yamd3s
import qs.qml.shell.bar
import qs.qml.shell.hub
import qs.qml.services
import qs.qml.shell.lockscreen
import qs.qml.shell.settings
import qs.qml.notifications
import "./qml/widgets"

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

    Widgets {
    }
}
