import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtMultimedia

Scope {
    NotificationServer {
        id: notificationServer

        imageSupported: true
        extraHints: ["sound"]

        onNotification: n => {
            n.tracked = true

            if (!n.hints["suppress-sound"] && !n.lastGeneration) {
                notificationSound.stop()
                
                if (n.hints["sound-file"]) {
                    console.log(n.hints["sound-file"])
                    notificationSound.source = n.hints["sound-file"]
                } else {
                    notificationSound.source = Qt.resolvedUrl("core_1.wav")
                }
                
                notificationSound.play()
            }
        }
    }

    SoundEffect {
        id: notificationSound

        source: Qt.resolvedUrl("core_1.wav")
        
        onStatusChanged: {
            if (status === SoundEffect.Error) {
                console.warn("Failed to load notification sound")
            }
        }
    }

    Variants {
        model: Quickshell.screens
        
        PanelWindow {
            required property var modelData
            screen: modelData
            
            anchors {
                top: true
                right: true
            }

            margins {
                top: 4
                right: 4
            }

            implicitWidth: notificationStack.implicitWidth
            implicitHeight: notificationStack.implicitHeight
        
            color: "transparent"
            focusable: false
            WlrLayershell.layer: WlrLayer.Overlay

            ColumnLayout {
                id: notificationStack

                spacing: NotificationStyle.toastSpacing
            
                Repeater {
                    model: notificationServer.trackedNotifications

                    NotificationToast {
                        required property Notification modelData
                        notification: modelData
                    }
                }
            }
        }
    }
}
