import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Scope {
    NotificationServer {
        id: notificationServer

        onNotification: n => n.tracked = true
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
