import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root
    
    readonly property MprisPlayer playerctld: Mpris.players.values.find(p => p.dbusName === "org.mpris.MediaPlayer2.playerctld");
    
    WlrLayershell.layer: WlrLayer.Bottom
    color: "transparent"

    anchors {
        right: true
        bottom: true
    }

    margins {
        right: 32
        bottom: 32
    }

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    ColumnLayout {
        id: content

        spacing: 8
        
        // Header
        ColumnLayout {
            Layout.fillWidth: true

            spacing: 4
            
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 2
                color: "#cecece"
            }
            
            Text {
                Layout.fillWidth: true
                Layout.maximumWidth: parent.width
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                
                text: root.playerctld.trackTitle
                color: "#cecece"
                font.family: "FOT-NewRodin Pro"
                font.pointSize: 12
            }
            
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 2
                color: "#cecece"
            }
        }
        
        Item {
            Layout.fillWidth: true

            implicitHeight: metadata.implicitHeight

            Text {
                id: metadata

                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                
                text: `${root.playerctld.trackArtist} — ${root.playerctld.trackAlbum}`
                color: "#cecece"
                font.family: "FOT-NewRodin Pro"
                font.pointSize: 10
                wrapMode: Text.Wrap
            }
        }

        Item {
            id: artworkFrame

            readonly property real imageSize: 256
            readonly property real imagePadding: 6

            Layout.preferredWidth: imageSize + imagePadding * 2
            Layout.preferredHeight: imageSize + imagePadding * 2
            
            Image {
                source: root.playerctld.trackArtUrl

                anchors.fill: parent
                anchors.margins: artworkFrame.imagePadding

                layer.enabled: true
                layer.smooth: true
                layer.effect: ShaderEffect {
                    fragmentShader: Qt.resolvedUrl("Shaders/mpris-gradient.frag.qsb")

                    onStatusChanged: {
                        if (status === ShaderEffect.Error) {
                            console.error(`Failed to load MPRIS palette shader: ${log}`)
                        }
                    }
                }
            }

            // Default, faint border
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.width: 3
                border.color: "#cecece"
                opacity: 0.4
            }

            ProgressBorder {
                anchors.fill: parent
                progress: {
                    if (!root.playerctld.positionSupported) return 0.0
                    if (!root.playerctld.lengthSupported) return 0.0
                    
                    return root.playerctld.position / root.playerctld.length
                }
            }

            // See note: <https://quickshell.org/docs/v0.3.0/types/Quickshell.Services.Mpris/MprisPlayer/#position>
            // TL;DR: position does not reactively update by default
            FrameAnimation {
                running: root.playerctld.playbackState === MprisPlaybackState.Playing
                onTriggered: root.playerctld.positionChanged()
            }
        }
    }

    // Text {
    //     text: root.playerctld.dbusName
    // }
}
