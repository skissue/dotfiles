//@ pragma UseQApplication
// TODO implement our own menus so they're not ugly

import Quickshell
import qs.Bar
import qs.Backdrop
import qs.Lock
import qs.Notifications

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
        
        Scope {
            id: screenScope
            
            required property var modelData

            Wallpaper {
                screen: screenScope.modelData
            }

            MprisPanel {
                screen: screenScope.modelData
            }
        }
    }

    SessionLock {}

    Notifications {}
}
