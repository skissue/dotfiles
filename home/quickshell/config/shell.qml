//@ pragma UseQApplication
// TODO implement our own menus so they're not ugly

import Quickshell
import qs.Bar
import qs.Overlay
import qs.Backdrop
import qs.Lock

ShellRoot {
    // TransmissionDemo {}

    Variants {
        model: Quickshell.screens
        
        Bar {
            required property var modelData
            screen: modelData
        }
    }

    Variants {
        model: Quickshell.screens
        
        Wallpaper {
            required property var modelData
            screen: modelData
        }
    }

    SessionLock {}
}
