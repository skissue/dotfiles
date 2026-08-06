import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property string title
    required property string summary
    required property string body
    property url imageSource

    implicitWidth: NotificationStyle.cardWidth
    implicitHeight: NotificationStyle.cardHeight

    Rectangle {
        anchors.fill: parent
        color: NotificationStyle.panel
        opacity: 0.9
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: NotificationStyle.headerHeight
            Layout.leftMargin: 3
            Layout.rightMargin: 3

            color: NotificationStyle.header
            opacity: 0.92

            Rectangle {
                anchors {
                    left: parent.left
                    leftMargin: 14
                    verticalCenter: parent.verticalCenter
                }

                width: 12
                height: 12
                color: NotificationStyle.rule
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

                text: root.title.toUpperCase()
                color: NotificationStyle.ink
                elide: Text.ElideRight
                font.family: NotificationStyle.fontFamily
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
                        color: NotificationStyle.ink
                        opacity: 0.82
                    }
                }
            }
        }

        Item {
            id: contentArea

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: NotificationStyle.contentPadding
            Layout.rightMargin: NotificationStyle.contentPadding
            Layout.topMargin: 12
            Layout.bottomMargin: 15

            RowLayout {
                anchors.fill: parent
                spacing: NotificationStyle.contentGap

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 0

                    Text {
                        Layout.fillWidth: true

                        text: root.summary
                        color: NotificationStyle.ink
                        elide: Text.ElideRight
                        font.family: NotificationStyle.fontFamily
                        font.pixelSize: 12
                        font.letterSpacing: 1.2
                        font.weight: Font.DemiBold
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 2
                        Layout.topMargin: 8

                        color: NotificationStyle.rule
                        opacity: 0.78
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 2
                        Layout.topMargin: 5

                        Rectangle {
                            width: parent.width * 0.64
                            height: parent.height
                            color: NotificationStyle.mutedInk
                            opacity: 0.55
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.topMargin: 13

                        text: root.body
                        color: NotificationStyle.ink
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                        maximumLineCount: 3
                        font.family: NotificationStyle.fontFamily
                        font.pixelSize: 14
                        font.letterSpacing: 0.7
                        lineHeight: 1.35
                    }
                }

                Rectangle {
                    id: divider

                    Layout.preferredWidth: NotificationStyle.dividerWidth
                    Layout.fillHeight: true
                    Layout.topMargin: 7
                    Layout.bottomMargin: 5

                    color: NotificationStyle.rule
                    opacity: 0.9
                }

                Item {
                    Layout.preferredWidth: NotificationStyle.imagePaneWidth
                    Layout.fillHeight: true

                    Rectangle {
                        anchors.fill: parent
                        color: NotificationStyle.rule
                        opacity: 0.055
                    }

                    Image {
                        readonly property bool useFallback: root.imageSource.toString() === ""
                        
                        anchors.fill: parent
                        anchors.margins: useFallback ? 8 : 0

                        source: useFallback
                            ? Quickshell.shellPath("assets/yorha-logo.svg")
                            : root.imageSource
                        fillMode: Image.PreserveAspectFit
                        opacity: 0.6
                    }

                    Rectangle {
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                        }

                        height: 1
                        color: NotificationStyle.rule
                        opacity: 0.3
                    }

                    Rectangle {
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }

                        height: 1
                        color: NotificationStyle.rule
                        opacity: 0.3
                    }
                }
            }
        }
    }

    NotificationChrome {
        anchors.fill: parent
        dividerX: contentArea.x + divider.x + divider.width / 2
    }
}
