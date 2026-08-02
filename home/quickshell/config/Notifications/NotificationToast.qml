import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    required property Notification notification

    readonly property color panelColor: "#353331"
    readonly property color titleColor: "#2a2927"
    readonly property color ink: "#ded8c8"
    readonly property color mutedInk: "#aaa597"
    readonly property color rule: "#f1ead6"
    readonly property int dividerX: 418

    implicitWidth: 590
    implicitHeight: 184
    color: panelColor
    opacity: 0.9
    Layout.bottomMargin: 10

    Timer {
        interval: 5000
        running: true
        onTriggered: root.notification.expire()
    }

    Repeater {
        model: 23

        Rectangle {
            required property int index

            y: index * 8
            width: root.width
            height: 1
            color: root.rule
            opacity: 0.025
        }
    }

    Rectangle {
        id: titleBar

        x: 3
        width: root.width - 6
        height: 31
        color: root.titleColor
        opacity: 0.92

        Rectangle {
            anchors {
                left: parent.left
                leftMargin: 14
                verticalCenter: parent.verticalCenter
            }

            width: 12
            height: 12
            color: root.rule
            opacity: 0.72
        }

        Text {
            anchors {
                left: parent.left
                leftMargin: 40
                right: signalBars.left
                rightMargin: 12
                verticalCenter: parent.verticalCenter
            }

            text: root.notification.appName.toUpperCase()
            color: root.ink
            elide: Text.ElideRight
            font.family: "PragmataPro"
            font.pixelSize: 11
            font.letterSpacing: 1.4
            font.weight: Font.DemiBold
        }

        Row {
            id: signalBars

            anchors {
                right: parent.right
                rightMargin: 13
                verticalCenter: parent.verticalCenter
            }

            spacing: 4

            Repeater {
                model: 4

                Rectangle {
                    required property int index

                    anchors.bottom: parent.bottom
                    width: 3
                    height: 4 + index * 2
                    color: root.ink
                    opacity: 0.82
                }
            }
        }
    }

    Rectangle {
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        width: 3
        color: root.rule
        opacity: 0.95
    }

    Rectangle {
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }

        width: 3
        color: root.rule
        opacity: 0.95
    }

    Rectangle {
        x: root.dividerX - 1
        y: 50
        width: 2
        height: root.height - 70
        color: root.rule
        opacity: 0.9
    }

    Item {
        id: messagePanel

        x: 18
        y: 43
        width: root.dividerX - x - 18
        height: root.height - y - 15

        Text {
            id: summary

            width: parent.width
            text: root.notification.summary
            color: root.ink
            elide: Text.ElideRight
            font.family: "PragmataPro"
            font.pixelSize: 12
            font.letterSpacing: 1.2
            font.weight: Font.DemiBold
        }

        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
            }

            y: 24
            height: 2
            color: root.rule
            opacity: 0.78
        }

        Rectangle {
            y: 31
            width: parent.width * 0.64
            height: 2
            color: root.mutedInk
            opacity: 0.55
        }

        Text {
            y: 48
            width: parent.width
            height: parent.height - y
            text: root.notification.body
            color: root.ink
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            maximumLineCount: 3
            font.family: "PragmataPro"
            font.pixelSize: 14
            font.letterSpacing: 0.7
            lineHeight: 1.35
        }
    }

    Item {
        x: root.dividerX + 16
        y: 43
        width: root.width - x - 18
        height: root.height - y - 15

        Rectangle {
            anchors.fill: parent
            color: root.rule
            opacity: 0.055
        }

        Image {
            anchors.fill: parent

            source: root.notification.image
            visible: source != ""
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            height: 1
            color: root.rule
            opacity: 0.3
        }

        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            height: 1
            color: root.rule
            opacity: 0.3
        }
    }

    Repeater {
        model: [
            { x: 11, y: titleBar.height + 7 },
            { x: root.dividerX, y: titleBar.height + 7 },
            { x: root.width - 11, y: titleBar.height + 7 },
            { x: 11, y: root.height - 11 },
            { x: root.dividerX, y: root.height - 11 },
            { x: root.width - 11, y: root.height - 11 }
        ]

        Item {
            required property var modelData

            x: modelData.x - width / 2
            y: modelData.y - height / 2
            width: 18
            height: 18

            Rectangle {
                anchors.centerIn: parent
                width: 16
                height: 16
                radius: 8
                color: root.rule
                opacity: 0.1
            }

            Rectangle {
                anchors.centerIn: parent
                width: 9
                height: 9
                radius: 4.5
                color: root.rule
                opacity: 0.22
            }

            Rectangle {
                anchors.centerIn: parent
                width: 4
                height: 4
                radius: 2
                color: root.rule
            }
        }
    }
}
