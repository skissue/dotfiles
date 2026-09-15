import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls

FocusScope {
    id: root

    focus: StackLayout.isCurrentItem

    signal close

    // readonly property list<string> actions: ["Save", "Load", "Settings", "Controls", "Network", "Play Records", "Return to Title Screen", "Exit Game"]
    readonly property list<Action> actions: [
        Action {
            text: "Lock"
            onTriggered: SessionManagement.lock()
        },
        Action {
            text: "Suspend"
            onTriggered: SessionManagement.suspend()
        },
        Action {
            text: "Hibernate"
        },
        Action {
            text: "Log Out"
        },
        Action {
            text: "Reboot"
        },
        Action {
            text: "Shut Down"
        }
    ]
    property int selectedAction: 0

    function cycleAction(offset: int): void {
        selectedAction = (selectedAction + offset + actions.length) % actions.length
    }

    function triggerAction(index: int): void {
        actions[index].trigger()
        close()
    }

    function triggerSelected(): void {
        triggerAction(selectedAction)
    }

    Keys.onUpPressed: root.cycleAction(-1)
    Keys.onDownPressed: root.cycleAction(1)
    Keys.onReturnPressed: root.triggerSelected()
    Keys.onEnterPressed: root.triggerSelected()

    Text {
        id: title

        text: "SYSTEM"
        color: "#4a4535"

        font.family: "FOT-NewRodin Pro"
        font.pointSize: 36
        font.letterSpacing: 8

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#4a4535"
            shadowOpacity: 0.45
            shadowBlur: 0.05
            shadowHorizontalOffset: 8
            shadowVerticalOffset: 8
        }
    }

    FlexboxLayout {
        anchors {
            top: title.bottom
            left: title.left
            bottom: parent.bottom

            topMargin: 64
            leftMargin: 64
            bottomMargin: 192
        }

        direction: FlexboxLayout.Column
        justifyContent: FlexboxLayout.JustifySpaceBetween

        Repeater {
            model: root.actions

            Rectangle {
                id: listItem
                required property Action modelData
                required property int index

                readonly property bool isSelected: index === root.selectedAction

                implicitWidth: 450
                implicitHeight: 48

                color: isSelected ? "#4a4535" : "#a8a39f86"

                Rectangle {
                    id: iconBlock

                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                        margins: 12
                    }

                    width: height
                    color: "#4a4535"
                }

                Text {
                    anchors {
                        left: iconBlock.right
                        verticalCenter: iconBlock.verticalCenter
                        leftMargin: 10
                        verticalCenterOffset: -2
                    }

                    text: listItem.modelData.text
                    color: "#4a4535"

                    font.family: "FOT-NewRodin Pro"
                    font.pointSize: 18
                    font.letterSpacing: 2
                }
            }
        }
    }
}
