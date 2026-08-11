import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

QtObject {
    id: root

    readonly property string colors_path: Quickshell.env("HOME") + "/.local/state/quickshell/generated/colors.json"
    readonly property string roles_path: Quickshell.shellDir + "/config/user_config.json"
    property bool loaded: false
    property var md3: ({
        "primary": "#a8c8ff",
        "on_primary": "#00315c",
        "primary_container": "#00497e",
        "on_primary_container": "#d4e3ff",
        "secondary": "#bcc7db",
        "on_secondary": "#263141",
        "secondary_container": "#3c4858",
        "on_secondary_container": "#d8e3f8",
        "tertiary": "#d6bee5",
        "on_tertiary": "#3b2948",
        "tertiary_container": "#523f5f",
        "on_tertiary_container": "#f3daff",
        "surface": "#111318",
        "on_surface": "#e2e2e9",
        "surface_dim": "#111318",
        "surface_bright": "#37393e",
        "surface_container_lowest": "#0c0e13",
        "surface_container_low": "#191c20",
        "surface_container": "#1d2024",
        "surface_container_high": "#282a2f",
        "surface_container_highest": "#33353a",
        "on_surface_variant": "#c3c6cf",
        "surface_variant": "#43474e",
        "surface_tint": "#a8c8ff",
        "outline": "#8c9199",
        "outline_variant": "#43474e",
        "background": "#111318",
        "on_background": "#e2e2e9",
        "shadow": "#000000",
        "scrim": "#000000",
        "inverse_surface": "#e2e2e9",
        "inverse_on_surface": "#2e3036",
        "inverse_primary": "#00629e",
        "error": "#ffb4ab",
        "on_error": "#690005",
        "error_container": "#93000a",
        "on_error_container": "#ffdad6"
    })
    property var palette: ({
    })
    property var base16: ({
    })
    // ---- module -> M3 role assignment ----
    property var roleMap: ({
        "workspaces": "primary",
        "clock": "primary",
        "switcher": "primary",
        "music_progress": "tertiary",
        "music_play_button": "primary",
        "volume_icon": "tertiary",
        "brightness_icon": "tertiary",
        "powermenu": "secondary"
    })
    // ---- matugen-driven palette ----
    property FileView colorsFile
    // ---- persisted role assignments ----
    property FileView userConfigFile

    userConfigFile: FileView {
        id: userConfigFile

        path: root.roles_path
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            try {
                const data = JSON.parse(text());
                if (data.theme_roles)
                    root.roleMap = data.theme_roles;

            } catch (e) {
                console.warn("Colors.qml: failed to parse user_config.json:", e);
            }
        }
        onLoadFailed: (error) => {
            console.warn("Colors.qml: user_config.json not found yet (" + error + "), creating with defaults");
            root.saveRoles();
        }
    }

    function setRole(moduleKey, role) {
        const updated = Object.assign({
        }, roleMap);
        updated[moduleKey] = role;
        roleMap = updated;
        saveRoles();
    }

    function roleColor(moduleKey, variant) {
        const role = roleMap[moduleKey] || "primary";
        const v = variant || "base";
        switch (v) {
        case "container":
            return root.md3[role + "_container"];
        case "on":
            return root.md3["on_" + role];
        case "on_container":
            return root.md3["on_" + role + "_container"];
        default:
            return root.md3[role];
        }
    }

    function saveRoles() {
        let fullConfig = {
        };
        try {
            fullConfig = JSON.parse(userConfigFile.text());
        } catch (e) {
        }
        fullConfig.theme_roles = root.roleMap;
        userConfigFile.setText(JSON.stringify(fullConfig, null, 2));
    }

    colorsFile: FileView {
        path: root.colors_path
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
                console.warn("Colors.qml: failed to parse matugen JSON:", e);
            }
        }
        onLoadFailed: (error) => {
            console.warn("Colors.qml: colors.json not found yet (" + error + "), using fallback palette");
        }
    }

}
