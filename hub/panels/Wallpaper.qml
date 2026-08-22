import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Y3s.Tokens
import Y3s.Globals

Item {
    id: root
    focus: true
    implicitWidth: Metrics.panelSizes.wallpaper.width
    implicitHeight: Metrics.panelSizes.wallpaper.height

    readonly property string defaultWallpaperDir: Quickshell.env("HOME") + "/.config/hypr/wallpapers/"
    readonly property string secretWallpaperDir: Quickshell.env("HOME") + "/.config/hypr/wallpapers/others/"

    property string wallpaperDir: defaultWallpaperDir
    property var wallpaperFiles: []

    readonly property var konamiSequence: [Qt.Key_Up, Qt.Key_Up, Qt.Key_Down, Qt.Key_Down, Qt.Key_Left, Qt.Key_Right, Qt.Key_Left, Qt.Key_Right, Qt.Key_B, Qt.Key_A]
    property var keyBuffer: []

    Connections {
        target: MatugenService
        function onWallpaperApplied(path) {
            if (root.wallpaperDir === root.secretWallpaperDir) {
                root.wallpaperDir = root.defaultWallpaperDir;
                listProc.command = ["find", root.wallpaperDir, "-maxdepth", "1", "-type", "f", "(", "-iname", "*.png", "-o", "-iname", "*.jpg", "-o", "-iname", "*.jpeg", ")"];
                root.wallpaperFiles = [];
                listProc.running = true;
            }
        }
    }

    Component.onCompleted: {
        listProc.running = true;
        root.forceActiveFocus();
    }

    Keys.onPressed: event => {
        keyBuffer.push(event.key);
        if (keyBuffer.length > konamiSequence.length) {
            keyBuffer.shift();
        }

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
                listProc.command = ["find", wallpaperDir, "-maxdepth", "1", "-type", "f", "(", "-iname", "*.png", "-o", "-iname", "*.jpg", "-o", "-iname", "*.jpeg", ")"];
                wallpaperFiles = [];
                listProc.running = true;
            }
        }
    }

    Process {
        id: listProc
        command: ["find", root.wallpaperDir, "-maxdepth", "1", "-type", "f", "(", "-iname", "*.png", "-o", "-iname", "*.jpg", "-o", "-iname", "*.jpeg", ")"]
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: line => {
                if (line.length > 0) {
                    wallpaperFiles = [...wallpaperFiles, line];
                }
            }
        }
    }

    GridView {
        anchors.fill: parent
        cellWidth: width / 4
        cellHeight: cellWidth * 0.65
        model: wallpaperFiles
        clip: true

        delegate: Item {
            required property string modelData
            width: GridView.view.cellWidth
            height: GridView.view.cellHeight

            Rectangle {
                anchors.fill: parent
                anchors.margins: 4
                radius: 12
                color: Colors.md3.surface_container_high
                clip: true

                Image {
                    id: wallpaperImage
                    anchors.fill: parent
                    source: "file://" + modelData
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    visible: false
                    scale: mouseHandler.containsMouse ? 2 : 1
                }

                MultiEffect {
                    anchors.fill: wallpaperImage
                    source: wallpaperImage
                    maskEnabled: true
                    maskSource: maskRect
                }

                Rectangle {
                    id: maskRect
                    anchors.fill: parent
                    radius: 12
                    visible: false
                    layer.enabled: true
                }

                MouseArea {
                    id: mouseHandler
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        MatugenService.applyWallpaper(modelData);
                        States.dashboardClose();
                    }
                }
            }
        }
    }
}
