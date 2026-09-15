import QtQuick

Item {
    id: root

    required property real dividerX
    property real headerHeight: NotificationStyle.headerHeight

    Repeater {
        model: Math.ceil(root.height / 8)

        Rectangle {
            required property int index

            y: index * 8
            width: root.width
            height: 1
            color: NotificationStyle.rule
            opacity: 0.025
        }
    }

    Rectangle {
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        width: 3
        color: NotificationStyle.rule
        opacity: 0.95
    }

    Rectangle {
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }

        width: 3
        color: NotificationStyle.rule
        opacity: 0.95
    }

    Repeater {
        model: [11, root.dividerX, root.width - 11]

        Item {
            required property real modelData

            x: modelData - width / 2
            width: topLight.implicitWidth
            height: root.height

            RegistrationLight {
                id: topLight

                anchors {
                    top: parent.top
                    topMargin: root.headerHeight - 2
                }
            }

            RegistrationLight {
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 2
                }
            }
        }
    }
}
