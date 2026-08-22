pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property MprisPlayer player: {
        const count = Mpris.players.count;
        const list = Mpris.players.values;

        if (!list || list.length === 0)
            return null;

        for (let i = 0; i < list.length; i++) {
            const p = list[i];
            if (!p)
                continue;

            const dbus = (p.dbusName || "").toLowerCase();
            const identity = (p.identity || "").toLowerCase();
            const entry = (p.desktopEntry || "").toLowerCase();

            if (dbus.includes("spotify") || identity.includes("spotify") || entry.includes("spotify")) {
                return p;
            }
        }

        return null;
    }

    // Direct top-level bindings catch player.positionChanged() signal triggers
    readonly property real rawPosition: root.player ? root.player.position : 0
    readonly property real rawLength: root.player ? root.player.length : 0

    readonly property QtObject track: QtObject {
        readonly property string title: root.player ? (root.player.trackTitle || "Unknown Title") : "Unknown Title"
        readonly property string artist: root.player ? (root.player.trackArtist || "Unknown Artist") : "Unknown Artist"
        readonly property string album: root.player ? root.player.trackAlbum : ""
        readonly property string albumArtist: root.player ? root.player.trackAlbumArtist : ""
        readonly property string artUrl: root.player ? root.player.trackArtUrl : ""
        readonly property int uniqueId: root.player ? root.player.uniqueId : 0
    }

    readonly property QtObject playback: QtObject {
        readonly property bool isPlaying: root.player ? root.player.isPlaying : false
        readonly property int state: root.player ? root.player.playbackState : MprisPlaybackState.Stopped
        readonly property real position: root.rawPosition
        readonly property real length: root.rawLength
        readonly property bool shuffle: root.player ? root.player.shuffle : false
        readonly property int loopState: root.player ? root.player.loopState : MprisLoopState.None
    }

    readonly property QtObject capabilities: QtObject {
        readonly property bool canControl: root.player ? root.player.canControl : false
        readonly property bool canGoNext: root.player ? root.player.canGoNext : false
        readonly property bool canGoPrevious: root.player ? root.player.canGoPrevious : false
        readonly property bool canTogglePlaying: root.player ? root.player.canTogglePlaying : false
        readonly property bool canSeek: root.player ? root.player.canSeek : false
        readonly property bool shuffleSupported: root.player ? root.player.shuffleSupported : false
        readonly property bool volumeSupported: root.player ? root.player.volumeSupported : false
        readonly property bool lengthSupported: root.player ? root.player.lengthSupported : false
    }

    // Reactive progress ratio (0.0 to 1.0)
    readonly property real progress: rawLength > 0 ? rawPosition / rawLength : 0

    // FrameAnimation updates player.positionChanged() on every screen refresh
    FrameAnimation {
        running: root.player !== null && root.playback.isPlaying
        onTriggered: {
            if (root.player) {
                root.player.positionChanged();
            }
        }
    }
}
