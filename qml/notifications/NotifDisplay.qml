import Yamd3s.Globals
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications

import qs.qml.hub.notifications

PanelWindow {
    id: root

    property var expiredMap: ({
    })

    function expireNotification(notif) {
        var key = notif.id !== undefined ? notif.id : notif;
        var copy = Object.assign({
        }, expiredMap);
        copy[key] = true;
        expiredMap = copy;
    }

    function isExpired(notif) {
        var key = notif.id !== undefined ? notif.id : notif;
        return !!expiredMap[key];
    }

    width: 360
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        bottom: true
        right: true
    }

    margins {
        top: 16
        bottom: 16
        right: 16
    }

    ColumnLayout {
        id: column

        width: parent.width - 16
        spacing: 12
        anchors.top: parent.top

        Repeater {
            model: NotifServer.trackedNotifications

            delegate: Item {
                id: wrapper

                required property var modelData
                property bool expanded: false
                readonly property bool expired: root.isExpired(modelData)
                readonly property real cardTargetHeight: Math.max(64, layout.implicitHeight + 24)

                function slideOutAndExpire() {
                    wrapper.expanded = false;
                    card.x = root.width;
                    exitTimer.start();
                }

                visible: implicitHeight > 0
                Layout.fillWidth: true
                implicitHeight: (expanded && !expired) ? cardTargetHeight : 0
                Component.onCompleted: {
                    Qt.callLater(() => {
                        if (!expired) {
                            wrapper.expanded = true;
                            card.x = 0;
                        }
                    });
                }

                Timer {
                    id: exitTimer

                    interval: 350
                    onTriggered: root.expireNotification(wrapper.modelData)
                }

                Rectangle {
                    id: card

                    width: parent.width
                    height: wrapper.implicitHeight
                    color: Theme.md3.inverse_surface ?? "#313033"
                    radius: 6
                    x: root.width
                    clip: true

                    Timer {
                        running: wrapper.modelData.urgency !== NotificationUrgency.Critical && !wrapper.expired
                        interval: 5000
                        onTriggered: wrapper.slideOutAndExpire()
                    }

                    RowLayout {
                        id: layout

                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        Image {
                            Layout.preferredHeight: 32
                            Layout.preferredWidth: 32
                            Layout.alignment: Qt.AlignTop
                            fillMode: Image.PreserveAspectFit
                            visible: source.toString() !== ""
                            source: wrapper.modelData.image || wrapper.modelData.appIcon || ""
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                Layout.fillWidth: true
                                visible: text !== ""
                                text: wrapper.modelData.summary
                                color: Theme.md3.inverse_on_surface ?? "#f4eff4"
                                font.pixelSize: 14
                                font.weight: Font.Medium
                                elide: Text.ElideRight
                                wrapMode: Text.WordWrap
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: text !== ""
                                text: wrapper.modelData.body
                                color: Theme.md3.inverse_on_surface ?? "#e6e1e5"
                                font.pixelSize: 12
                                opacity: 0.85
                                elide: Text.ElideRight
                                wrapMode: Text.WordWrap
                            }

                        }

                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: wrapper.slideOutAndExpire()
                    }

                    Behavior on x {
                        NumberAnimation {
                            duration: 350
                            easing.type: Easing.OutCubic
                        }

                    }

                }

                Behavior on implicitHeight {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutCubic
                    }

                }

            }

        }

    }

    mask: Region {
        item: column
    }

}
