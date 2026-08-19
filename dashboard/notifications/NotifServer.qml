import QtQuick
import Quickshell
import Quickshell.Services.Notifications
pragma Singleton

Singleton {
    id: root

    readonly property alias trackedNotifications: server.trackedNotifications

    NotificationServer {
        id: server

        actionsSupported: true
        bodySupported: true
        imageSupported: true
        onNotification: (n) => {
            return n.tracked = true;
        }
    }

}
