import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root

    readonly property list<string> menus: ["MAP", "QUESTS", "ITEMS", "WEAPONS", "SKILLS", "INTEL", "SYSTEM"]
    property int selected: 0

    function cycleSelection(offset: int): void {
        selected = (selected + offset + menus.length) % menus.length
    }

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore

    color: "#c1bda0"

    FocusScope {
        anchors.fill: parent
        focus: true

        // Any key:
        Keys.onPressed: event => {
            event.accepted = true

            switch (event.key) {
            case Qt.Key_Left:
                root.cycleSelection(-1)
                event.accepted = true
                break
            case Qt.Key_Right:
                root.cycleSelection(1)
                event.accepted = true
                break
            case Qt.Key_Escape:
                root.visible = false
                event.accepted = true
                break
            default:
                event.accepted = false
            }
        }

        Image {
            anchors.fill: parent
            source: Quickshell.shellPath("assets/bg.svg")
            fillMode: Image.PreserveAspectFit
        }

        PauseNavbar {
            id: navbar

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            menus: root.menus
            selected: root.selected
        }

        StackLayout {
            anchors {
                top: navbar.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                leftMargin: 58
                topMargin: 64
            }

            currentIndex: root.selected

            MapPage {}
            QuestsPage {}
            ItemsPage {}
            WeaponsPage {}
            SkillsPage {}
            IntelPage {}
            SystemPage {
                onClose: root.visible = false
            }
        }
    }
}
