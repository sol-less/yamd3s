import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

QtObject {
    id: root

    readonly property string colorsPath: Quickshell.env("HOME") + "/.local/state/quickshell/generated/colors.json"
    readonly property string themePath: Quickshell.shellDir + "/config/theme.json"
    property bool loaded: false
    
    property var md3: ({
        "primary": "#6750A4",
        "on_primary": "#FFFFFF",
        "primary_container": "#EADDFF",
        "on_primary_container": "#21005D",
        "secondary": "#625B71",
        "on_secondary": "#FFFFFF",
        "secondary_container": "#E8DEF8",
        "on_secondary_container": "#1D192B",
        "tertiary": "#7D5260",
        "on_tertiary": "#FFFFFF",
        "tertiary_container": "#FFD8E4",
        "on_tertiary_container": "#31111D",
        "error": "#B3261E",
        "on_error": "#FFFFFF",
        "surface": "#FEF7FF",
        "on_surface": "#1D1B20"
    })
    
    property var palette: ({})
    property var base16: ({})
    property var themeRoles: ({})

    property FileView colorsFile: FileView {
        path: root.colorsPath
        watchChanges: true
        onFileChanged: reload()
        Component.onCompleted: reload()
        onLoaded: {
            try {
                const fileContent = typeof text === "function" ? text() : text;
                const data = JSON.parse(fileContent);
                
                if (data.md3) root.md3 = data.md3;
                if (data.palette) root.palette = data.palette;
                if (data.base16) root.base16 = data.base16;

                root.loaded = true;
            } catch (e) {
                console.warn("Colors.qml: Failed to parse Matugen colors -> " + e);
            }
        }
    }

    property FileView themeFile: FileView {
        path: root.themePath
        watchChanges: true
        onFileChanged: reload()
        Component.onCompleted: reload()
        onLoaded: {
            try {
                const fileContent = typeof text === "function" ? text() : text;
                const data = JSON.parse(fileContent);
                if (data.themeRoles) root.themeRoles = data.themeRoles;
            } catch (e) {
                console.warn("Colors.qml: Failed to parse theme.json roles -> " + e);
            }
        }
    }

    function roleColor(moduleKey, variant) {
        if (variant === undefined) {
            variant = "base";
        }
        
        const role = themeRoles[moduleKey] || "primary";
        
        switch (variant) {
        case "container":
            return root.md3[`${role}_container`] || root.md3[role];
        case "on":
            return root.md3[`on_${role}`] || "#FFFFFF";
        case "onContainer":
            return root.md3[`on_${role}_container`] || "#000000";
        default:
            return root.md3[role] || "#000000";
        }
    }
}