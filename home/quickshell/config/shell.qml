//@ pragma UseQApplication
// TODO implement our own menus so they're not ugly

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
