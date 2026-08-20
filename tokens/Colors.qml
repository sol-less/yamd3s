import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

QtObject {
    id: root

    readonly property string colorsPath: Quickshell.env("HOME") + "/.local/state/quickshell/generated/colors.json"
    readonly property string rolesPath: Quickshell.shellDir + "/config/theme.json"
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
        "surface": "#FEF7FF",
        "on_surface": "#1D1B20",
        "surface_container_low": "#F7F2FA"
    })
    property var palette: ({
    })
    property var base16: ({
    })
    property var themeRoles: ({
        "workspaces": "primary",
        "clock": "primary",
        "switcher": "primary",
        "musicProgress": "tertiary",
        "musicPlayButton": "primary",
        "volumeIcon": "tertiary",
        "brightnessIcon": "tertiary",
        "powermenu": "secondary"
    })
    property FileView userConfigFile
    property FileView colorsFile

    function setRole(moduleKey, role) {
        themeRoles = Object.assign({
        }, themeRoles, {
            [moduleKey]: role
        });
        saveRoles();
    }

    function roleColor(moduleKey, variant = "base") {
        const role = themeRoles[moduleKey] || "primary";
        switch (variant) {
        case "container":
            return root.md3[`${role}_container`];
        case "on":
            return root.md3[`on_${role}`];
        case "onContainer":
            return root.md3[`on_${role}_container`];
        default:
            return root.md3[role];
        }
    }

    function saveRoles() {
        let config = {
        };
        try {
            config = JSON.parse(userConfigFile.text());
        } catch (e) {
        }
        config.themeRoles = root.themeRoles;
        userConfigFile.setText(JSON.stringify(config, null, 2));
    }

    userConfigFile: FileView {
        path: root.rolesPath
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            try {
                const data = JSON.parse(text());
                if (data.themeRoles)
                    root.themeRoles = data.themeRoles;

            } catch (e) {
                console.warn("Colors.qml: failed to parse user_config.json");
            }
        }
        onLoadFailed: () => {
            return saveRoles();
        }
    }

    colorsFile: FileView {
        path: root.colorsPath
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            try {
                const data = JSON.parse(text());
                if (data.md3)
                    root.md3 = data.md3;

                if (data.palette)
                    root.palette = data.palette;

                if (data.base16)
                    root.base16 = data.base16;

                root.loaded = true;
            } catch (e) {
                console.warn("Colors.qml: failed to parse matugen JSON");
            }
        }
    }

}
