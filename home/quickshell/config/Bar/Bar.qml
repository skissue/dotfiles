import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs.Services

PanelWindow {
    id: root

    property bool detached: Niri.activeWindowFor(screen.name) !== null
    property real backgroundOpacity: detached ? 1 : 0
    
    Behavior on backgroundOpacity {
        NumberAnimation {
            duration: 240
            easing.type: Easing.OutCubic
        }
    }

    color: "transparent"
    implicitWidth: 40

    anchors {
        top: true
        bottom: true
        left: true
    }

    margins {
        top: 8
        bottom: 8
        left: 8
    }

    Rectangle {
        anchors.fill: parent
        color: "#0e1415"
        opacity: backgroundOpacity
    }

    ColumnLayout {
        id: barTop

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 8

        spacing: 16

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: -2

            Text {
                Layout.alignment: Qt.AlignBaseline
                text: "["
                color: "#cecece"
                font.family: "PragmataPro"
                font.pointSize: 16
            }

            Text {
                Layout.alignment: Qt.AlignBaseline
                text: ""
                color: "#cecece"
                font.family: "PragmataPro"
                font.pointSize: 14
            }

            Text {
                Layout.alignment: Qt.AlignBaseline
                text: "]"
                color: "#cecece"
                font.family: "PragmataPro"
                font.pointSize: 16
            }
        }

        Workspaces {
            Layout.alignment: Qt.AlignHCenter
            output: screen.name
        }
    }

    Item {
        anchors.top: barTop.bottom
        anchors.bottom: barBottom.top
        width: parent.width

        Text {
            anchors.centerIn: parent

            // Rotation swaps width/height
            rotation: -90
            width: parent.height
            height: parent.width
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            
            text: Niri.activeWindowFor(screen.name)?.title ?? ""
            font.family: "PragmataPro"
            font.italic: true
            font.pointSize: 11
            color: "#cecece"
        }
    }

    ColumnLayout {
        id: barBottom
        
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16

        spacing: 8

        Item {
            Layout.fillWidth: true
            implicitHeight: content.implicitHeight + 16

            Rectangle {
                anchors.fill: parent
                color: "#1d2324"
                opacity: backgroundOpacity
            }
            
            Systray {
                id: content
                anchors.centerIn: parent
                Layout.alignment: Qt.AlignHCenter
            }
        }

        
        Clock {
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
