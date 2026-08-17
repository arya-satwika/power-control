pragma ComponentBehavior: Bound
import QtQuick
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins
import Quickshell.Io

PluginComponent {
    id: root

    readonly property var icons: ({
        "power-saver":  "eco",
        "balanced"   :   "balance",
        "performance":  "bolt"
        })
    readonly property list<string> profiles: ["power-saver", "balanced", "performance"]
    property string currentProfile: ""
    property string currentIcon: icons[currentProfile]


    Process {
        id: getprofile
        command:["powerprofilesctl", "get" ]
        stdout: StdioCollector {
            onStreamFinished: root.currentProfile=text.trim()
        }
    }
    Process {
        id: seteco
        command:["powerprofilesctl", "set", "power-saver" ]
        stdout: StdioCollector {
            onStreamFinished: root.currentProfile=root.profiles[0]
        }
    }
    Process {
        id: setbalanced
        command:["powerprofilesctl", "set", "balanced" ]
        stdout: StdioCollector {
            onStreamFinished: root.currentProfile=root.profiles[1]
        }
    }
    Process {
        id: setperformance
        command:["powerprofilesctl", "set", "performance" ]
        stdout: StdioCollector {
            onStreamFinished: root.currentProfile=root.profiles[2]
        }
    }
    Component.onCompleted: {
        getprofile.running=true
    }
    function cycleProfiles(){
        if (root.currentProfile == profiles[0]) {
            setbalanced.running=true
        }else if (root.currentProfile == profiles[1]) {
            setperformance.running=true
        }else if (root.currentProfile == profiles[2]) {
            seteco.running=true
        }else{
            ToastService.showError("shit dont work")
        }
        // ToastService.showInfo("Changed to " + root.currentProfile)
    }

    verticalBarPill: Component {
        Column{
            DankIcon{
                name: root.currentIcon
                size: Theme.fontSizeXLarge
                color: Theme.secondary
                implicitHeight: Theme.fontSizeXLarge
                filled: true
                MouseArea{
                    cursorShape: Qt.PointingHandCursor
                    anchors.fill:parent
                    onClicked: {
                        root.cycleProfiles()
                    }
                    hoverEnabled: true
                    preventStealing: true
                }
            }

        }
    }
    horizontalBarPill: Component {
        Row{
            DankIcon{
                name: root.currentIcon
                size: Theme.fontSizeXLarge
                implicitHeight: Theme.fontSizeXLarge
                color: Theme.secondary
                filled: true
                MouseArea{
                    cursorShape: Qt.PointingHandCursor
                    anchors.fill:parent
                    onClicked: {
                        root.cycleProfiles()
                    }
                    hoverEnabled: true
                    preventStealing: true
                }
            }

        }
    }

}