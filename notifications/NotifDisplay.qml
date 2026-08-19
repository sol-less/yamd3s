import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland
import Y3s.Lib
import Y3s.Tokens
import qs.dashboard.notifications

PanelWindow {
    id: root

    width: 360
    implicitHeight: column.implicitHeight + 32
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        right: true
    }

    margins {
        top: 16
    }

    ColumnLayout {
        id: column

        width: parent.width - 16
        spacing: 12

        Repeater {
            model: NotifServer.trackedNotifications

            delegate: Item {
                id: wrapper

                required property var modelData

                function slideOutAndDismiss() {
                    card.x = root.width;
                    exitTimer.start();
                }

                Layout.fillWidth: true
                implicitHeight: card.implicitHeight

                Timer {
                    id: exitTimer

                    interval: 350
                    onTriggered: wrapper.modelData.dismiss()
                }

                Rectangle {
                    id: card

                    width: parent.width
                    implicitHeight: Math.max(64, layout.implicitHeight + 24)
                    // MD3 Floating Surface: Inverse surface tone for floating contrast
                    color: Colors.md3.inverse_surface ?? "#313033"
                    // MD3 Shape: Uniform Extra Large rounding on all corners
                    radius: 16
                    x: root.width
                    Component.onCompleted: {
                        card.x = 0;
                    }

                    Timer {
                        running: wrapper.modelData.urgency !== NotificationUrgency.Critical
                        interval: 5000
                        onTriggered: wrapper.slideOutAndDismiss()
                    }

                    RowLayout {
                        id: layout

                        anchors.fill: parent
                        anchors.margins: 16 // MD3 16dp grid padding
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
                                color: Colors.md3.inverse_on_surface ?? "#f4eff4"
                                font.pixelSize: 14
                                font.weight: Font.Medium
                                elide: Text.ElideRight
                                wrapMode: Text.WordWrap
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: text !== ""
                                text: wrapper.modelData.body
                                color: Colors.md3.inverse_on_surface ?? "#e6e1e5"
                                font.pixelSize: 12
                                opacity: 0.85
                                elide: Text.ElideRight
                                wrapMode: Text.WordWrap
                            }

                        }

                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: wrapper.slideOutAndDismiss()
                    }

                    Behavior on x {
                        NumberAnimation {
                            duration: 350
                            easing.type: Easing.OutCubic // MD3 Emphasized Decelerate
                        }

                    }

                }

            }

        }

    }

}
