import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property Notification notification

    implicitWidth: card.implicitWidth
    implicitHeight: card.implicitHeight

    Timer {
        interval: 5000
        running: true
        onTriggered: root.notification.expire()
    }

    TransmissionCard {
        id: card

        anchors.fill: parent
        title: root.notification.appName
        summary: root.notification.summary
        body: root.notification.body
        imageSource: root.notification.image
    }
}
