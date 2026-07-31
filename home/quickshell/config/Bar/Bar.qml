import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs.Services

PanelWindow {
    id: root

    color: "#0e1415"
    implicitWidth: 40

    anchors {
        top: true
        bottom: true
        left: true
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Workspaces {
        output: screen.name
                
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 16
    }

    ColumnLayout {
        anchors.centerIn: parent

        Text {
            color: "#cecece"
            text: Qt.formatDateTime(clock.date, "hh")
        }

        Text {
            color: "#cecece"
            text: Qt.formatDateTime(clock.date, "mm")
        }


        Text {
            color: "#cecece"
            text: Qt.formatDateTime(clock.date, "ss")
        }
    }
}
