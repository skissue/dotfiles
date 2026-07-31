import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    spacing: 8

    Repeater {
        model: SystemTray.items

        Item {
            required property SystemTrayItem modelData

            id: icon

            implicitWidth: 20
            implicitHeight: 20

            Image {
                anchors.fill: parent
                source: modelData.icon
                fillMode: Image.PreserveAspectFit
            }

            QsMenuAnchor {
                id: menuAnchor
                menu: modelData.menu
                anchor.item: icon
            }

            TapHandler {
                acceptedButtons: Qt.LeftButton
                onTapped: modelData.activate()
            }

            TapHandler {
                acceptedButtons: Qt.RightButton
                onTapped: menuAnchor.open()
            }
        }
    }
}
