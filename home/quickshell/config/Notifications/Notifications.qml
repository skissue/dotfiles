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

    PanelWindow {
        anchors {
            top: true
            right: true
        }

        implicitWidth: notificationStack.implicitWidth
        implicitHeight: notificationStack.implicitHeight
        
        color: "transparent"
        focusable: false
        WlrLayershell.layer: WlrLayer.Overlay

        ColumnLayout {
            id: notificationStack
            
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
