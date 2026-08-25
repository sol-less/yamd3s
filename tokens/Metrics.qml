import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

QtObject {
    id: root

    property var bar: ({
        "height": 42,
        "spacing": 8,
        "margin": 8
    })
    property var spacing: ({
        "compact": 4,
        "small": 8,
        "medium": 12,
        "large": 16,
        "huge": 24
    })
    property var radii: ({
        "compact": 4,
        "small": 8,
        "medium": 12,
        "large": 16,
        "huge": 24
    })
    property var launcher: ({
        "columns": 5,
        "iconSize": 48,
        "itemWidth": 90,
        "itemHeight": 90,
        "spacing": 8
    })
    property var typography: ({
        "clockSize": 14,
        "panelTitleSize": 16
    })
    property var icons: ({
        "size": 20,
        "strokeWidth": 2
    })
    property var panelMax: ({
        "width": 800,
        "height": 900
    })
    property var panelSizes: ({
    })
    property FileView layoutFile
    property FileView panelsFile
    property FileView launcherFile
    property FileView themeFile

    function panelWidth(name) {
        return panelSizes[name].width ?? 400;
    }

    function panelHeight(name) {
        return panelSizes[name].height ?? 400;
    }

    panelsFile: FileView {
        path: Quickshell.shellDir + "/config/panels.json"
        watchChanges: true
        onFileChanged: reload()
        Component.onCompleted: reload()
        onLoaded: {
            try {
                const data = JSON.parse(text());
                if (data.max)
                    root.panelMax = Object.assign({
                }, root.panelMax, data.max);

                root.panelSizes = data;
            } catch (e) {
                console.warn("Metrics.qml: Failed to parse panels.json -> " + e);
            }
        }
    }

    layoutFile: FileView {
        path: Quickshell.shellDir + "/config/layout.json"
        watchChanges: true
        onFileChanged: reload()
        Component.onCompleted: reload()
        onLoaded: {
            try {
                const data = JSON.parse(text());
                if (data.bar)
                    root.bar = Object.assign({
                }, root.bar, data.bar);

                if (data.spacing)
                    root.spacing = Object.assign({
                }, root.spacing, data.spacing);

                if (data.radii)
                    root.radii = Object.assign({
                }, root.radii, data.radii);

            } catch (e) {
                console.warn("Metrics.qml: Failed to parse layout.json -> " + e);
            }
        }
    }

    launcherFile: FileView {
        path: Quickshell.shellDir + "/config/launcher.json"
        watchChanges: true
        onFileChanged: reload()
        Component.onCompleted: reload()
        onLoaded: {
            try {
                const data = JSON.parse(text());
                if (data.grid)
                    root.launcher = Object.assign({
                }, root.launcher, data.grid);

            } catch (e) {
                console.warn("Metrics.qml: Failed to parse launcher.json grid -> " + e);
            }
        }
    }

    themeFile: FileView {
        path: Quickshell.shellDir + "/config/theme.json"
        watchChanges: true
        onFileChanged: reload()
        Component.onCompleted: reload()
        onLoaded: {
            try {
                const data = JSON.parse(text());
                if (data.typography)
                    root.typography = Object.assign({
                }, root.typography, data.typography);

                if (data.icons)
                    root.icons = Object.assign({
                }, root.icons, data.icons);

            } catch (e) {
                console.warn("Metrics.qml: Failed to parse theme.json -> " + e);
            }
        }
    }

}
