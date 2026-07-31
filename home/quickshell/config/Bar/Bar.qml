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

    Workspaces {
        id: barTop
        
        output: screen.name
                
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 16
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
            font.pointSize: 11
            color: "#cecece"
        }
    }

    ColumnLayout {
        id: barBottom
        
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 16

        spacing: 16

        Systray {}
        
        Clock {}
    }
}
