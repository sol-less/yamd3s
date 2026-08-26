import QtQuick
import Quickshell
import Quickshell.Io
import Yamd3s.Core
import Yamd3s.Globals

Item {
    id: root

    readonly property string defaultWallpaperDir: Quickshell.env("HOME") + "/.config/hypr/wallpapers/"
    readonly property string secretWallpaperDir: Quickshell.env("HOME") + "/.config/hypr/wallpapers/others/"
    property string wallpaperDir: defaultWallpaperDir
    property var wallpaperFiles: []
    property var _pendingFiles: []
    readonly property var konamiSequence: [Qt.Key_Up, Qt.Key_Up, Qt.Key_Down, Qt.Key_Down, Qt.Key_Left, Qt.Key_Right, Qt.Key_Left, Qt.Key_Right, Qt.Key_B, Qt.Key_A]
    property var keyBuffer: []

    function refreshWallpapers() {
        _pendingFiles = [];
        listProc.command = ["find", wallpaperDir, "-maxdepth", "1", "-type", "f", "(", "-iname", "*.png", "-o", "-iname", "*.jpg", "-o", "-iname", "*.jpeg", ")"];
        listProc.running = true;
    }

    focus: true
    implicitWidth: ConfigManager.panels.wallpaper.width
    implicitHeight: ConfigManager.panels.wallpaper.height
    Component.onCompleted: {
        refreshWallpapers();
        root.forceActiveFocus();
    }
    Keys.onPressed: (event) => {
        keyBuffer.push(event.key);
        if (keyBuffer.length > konamiSequence.length)
            keyBuffer.shift();

        if (keyBuffer.length === konamiSequence.length) {
            let matched = true;
            for (let i = 0; i < konamiSequence.length; i++) {
                if (keyBuffer[i] !== konamiSequence[i]) {
                    matched = false;
                    break;
                }
            }
            if (matched) {
                wallpaperDir = wallpaperDir === defaultWallpaperDir ? secretWallpaperDir : defaultWallpaperDir;
                keyBuffer = [];
                refreshWallpapers();
            }
        }
    }

    Connections {
        function onWallpaperApplied(path) {
            if (root.wallpaperDir === root.secretWallpaperDir) {
                root.wallpaperDir = root.defaultWallpaperDir;
                refreshWallpapers();
            }
        }

        target: MatugenService
    }

    Process {
        id: listProc

        onExited: {
            root.wallpaperFiles = root._pendingFiles;
        }

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: (line) => {
                const trimmed = line.trim();
                if (trimmed.length > 0)
                    root._pendingFiles.push(trimmed);

            }
        }

    }

    GridView {
        id: gridView

        anchors.fill: parent
        cellWidth: Math.floor(width / 4)
        cellHeight: Math.floor(cellWidth * 0.65)
        model: wallpaperFiles
        clip: true
        cacheBuffer: cellHeight * 2

        delegate: Item {
            required property string modelData

            width: GridView.view.cellWidth
            height: GridView.view.cellHeight

            Rectangle {
                anchors.fill: parent
                anchors.margins: ConfigManager.layout.spacing.compact
                radius: ConfigManager.layout.radii.medium
                color: Theme.md3.surface_container_high
                clip: true

                Image {
                    id: wallpaperImage

                    anchors.fill: parent
                    source: "file://" + modelData
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    sourceSize: Qt.size(320, 200)
                    scale: mouseHandler.containsMouse ? 1.05 : 1

                    Behavior on scale {
                        NumberAnimation {
                            duration: 150
                            easing.type: Easing.OutQuad
                        }

                    }

                }

                MouseArea {
                    id: mouseHandler

                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        MatugenService.applyWallpaper(modelData);
                        States.hubClose();
                    }
                }

            }

        }

    }

}
