import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    WlrLayershell.layer: WlrLayer.Background
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        right: true
        bottom: true
        left: true
    }

    Image {
        anchors.fill: parent
        source: `${Quickshell.env("QS_WALLPAPER_DIRECTORY")}/0016.png`
        fillMode: Image.PreserveAspectCrop
    }
}
