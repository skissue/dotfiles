import Quickshell
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

Item {
    id: root

    required property list<string> menus
    required property int selected

    implicitHeight: navHeader.y + navHeader.height + 6
    height: implicitHeight

    // Little left-side prefix indent marker thingy
    Row {
        anchors {
            right: navHeader.left
            top: navHeader.top
            bottom: navHeader.bottom
            rightMargin: 28
        }

        spacing: 8

        Rectangle {
            width: 16
            height: parent.height
            color: "#7b7964"
            opacity: 0.9
        }

        Rectangle {
            width: 4
            height: parent.height
            color: "#7b7964"
            opacity: 0.9
        }
    }

    RowLayout {
        id: navHeader

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            leftMargin: 112
            rightMargin: 64
            topMargin: 42
        }

        spacing: 32

        Repeater {
            model: root.menus

            Rectangle {
                id: menuHeading

                required property string modelData
                required property int index
                readonly property bool isSelected: index === root.selected
                property real selectionProgress: isSelected ? 1 : 0
                property color contentColor: isSelected ? "#ccc9ac" : "#4a4535"
                property color inverseColor: isSelected ? "#4a4535" : "#ccc9ac"

                Behavior on selectionProgress {
                    NumberAnimation {
                        duration: 180
                        easing.type: Easing.InQuad
                    }
                }

                Behavior on contentColor {
                    ColorAnimation {
                        duration: 180
                        easing.type: Easing.InOutQuad
                    }
                }

                Behavior on inverseColor {
                    ColorAnimation {
                        duration: 180
                        easing.type: Easing.InOutQuad
                    }
                }

                implicitHeight: 48
                // This makes width distribute between rectangles
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                // AARRGGBB
                color: "#e8a39f86"

                // Above/below selection indicator lines
                Rectangle {
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.top
                        bottomMargin: 4 * menuHeading.selectionProgress
                    }

                    height: 2
                    color: "#4a4535"
                    opacity: menuHeading.selectionProgress
                }

                Rectangle {
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.bottom
                        topMargin: 4 * menuHeading.selectionProgress
                    }

                    height: 2
                    color: "#4a4535"
                    opacity: menuHeading.selectionProgress
                }

                // Selected color rectangle for animation
                Rectangle {
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                    }

                    width: menuHeading.isSelected ? parent.width : 0
                    color: "#e84a4535"

                    Behavior on width {
                        NumberAnimation {
                            duration: 320
                            easing.type: Easing.OutQuad
                        }
                    }
                }

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 10
                    }

                    spacing: 8

                    Rectangle {
                        Layout.alignment: Qt.AlignVCenter
                        implicitWidth: 30
                        implicitHeight: 30
                        color: menuHeading.contentColor

                        Image {
                            id: iconSource

                            anchors.fill: parent
                            source: Quickshell.shellPath(`assets/${menuHeading.modelData.toLowerCase()}.svg`)
                            fillMode: Image.PreserveAspectFit
                            visible: false
                        }

                        MultiEffect {
                            anchors.fill: parent
                            source: iconSource

                            colorization: 1
                            colorizationColor: menuHeading.inverseColor
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        // Move text up a little to account for some letters
                        // dipping below baseline
                        Layout.topMargin: -4

                        text: menuHeading.modelData
                        color: menuHeading.isSelected ? "#ccc9ac" : "#4a4535"
                        horizontalAlignment: Text.AlignLeft
                        font.family: "FOT-NewRodin Pro"
                        font.pointSize: 20
                        font.letterSpacing: 2

                        Behavior on color {
                            ColorAnimation {
                                duration: 160
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                }
            }
        }
    }
}
