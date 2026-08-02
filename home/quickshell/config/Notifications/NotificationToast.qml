import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    
    required property Notification notification

    color: "#0e1415"
    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    Timer {
        interval: 5000
        running: true
        onTriggered: root.notification.expire()
    }

    ColumnLayout {
        id: content
        
        Text {
            text: root.notification.appName
            color: "#cecece"
            font.pointSize: 14
        }

        Text {
            text: root.notification.summary
            color: "#cecece"
            font.pointSize: 14
        }

        Text {
            text: root.notification.body
            color: "#cecece"
            font.pointSize: 14
        }
    }
}
