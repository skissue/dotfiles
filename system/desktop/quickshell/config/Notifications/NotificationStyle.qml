pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property color panel: "#353331"
    readonly property color header: "#2a2927"
    readonly property color ink: "#ded8c8"
    readonly property color mutedInk: "#aaa597"
    readonly property color rule: "#f1ead6"

    readonly property string fontFamily: "PragmataPro"

    readonly property int cardWidth: 590
    readonly property int cardHeight: 184
    readonly property int headerHeight: 31
    readonly property int contentPadding: 18
    readonly property int contentGap: 16
    readonly property int imagePaneWidth: 138
    readonly property int dividerWidth: 2
    readonly property int toastSpacing: 10
}
