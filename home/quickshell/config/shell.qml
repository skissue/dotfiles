import Quickshell
import qs.Bar

ShellRoot {
    Variants {
        model: Quickshell.screens
        
        Bar {
            required property var modelData
            screen: modelData
        }
    }
}
