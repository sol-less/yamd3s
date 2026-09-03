import QtQuick
import Quickshell
import Quickshell.Services.Notifications
pragma Singleton

Singleton {
    id: root

    property bool dnd: false
    readonly property alias trackedNotifications: server.trackedNotifications

    NotificationServer {
        id: server

        actionsSupported: true
        bodySupported: true
        imageSupported: true
        actionIconsSupported: true
        onNotification: (n) => {
            if (root.dnd) {
                n.tracked = false;
                return ;
            }
            n.tracked = true;
        }
    }

}
