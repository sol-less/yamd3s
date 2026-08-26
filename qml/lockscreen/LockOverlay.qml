import QtQuick
import Quickshell
import Quickshell.Wayland
import Yamd3s.Globals

import qs.qml.lockscreen.components

ShellRoot {
    id: root

    property bool isUnlocking: false

    Connections {
        target: States
        onStartLockSequence: {
            root.isUnlocking = false;
            anim.animStart();
        }
    }

    LockContext {
        id: lockContext

        onUnlocked: {
            if (!root.isUnlocking)
                root.isUnlocking = true;

        }
    }

    WlSessionLock {
        id: lock

        locked: States.lockscreenActive

        WlSessionLockSurface {
            Rectangle {
                anchors.fill: parent
                color: Theme.md3.background
            }

            Item {
                id: surfaceWrapper

                anchors.fill: parent

                Connections {
                    function onIsUnlockingChanged() {
                        if (root.isUnlocking)
                            fadeOutAnim.start();

                    }

                    target: root
                }

                NumberAnimation {
                    id: fadeOutAnim

                    target: surfaceWrapper
                    property: "opacity"
                    to: 0
                    duration: 300
                    easing.type: Easing.InQuint
                    onFinished: {
                        States.lockscreenActive = false;
                    }
                }

                LockSurface {
                    id: visualLockSurface

                    anchors.fill: parent
                    context: lockContext
                }

                NumberAnimation on opacity {
                    from: 0
                    to: 1
                    duration: 300
                    easing.type: Easing.OutQuint
                }

            }

        }

    }

    LockAnim {
        id: anim

        onAnimStopped: States.lockscreenActive = true
        baseAnimLength: 2
    }

}
