import QtQuick

Item {
    implicitWidth: 18
    implicitHeight: 18

    Rectangle {
        anchors.centerIn: parent
        width: 16
        height: 16
        radius: width / 2
        color: NotificationStyle.rule
        opacity: 0.1
    }

    Rectangle {
        anchors.centerIn: parent
        width: 9
        height: 9
        radius: width / 2
        color: NotificationStyle.rule
        opacity: 0.22
    }

    Rectangle {
        anchors.centerIn: parent
        width: 4
        height: 4
        radius: width / 2
        color: NotificationStyle.rule
    }
}
