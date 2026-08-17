pragma ComponentBehavior: Bound
import QtQuick
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins
import Quickshell.Io

PluginComponent {
    id: root

    property list<string> icons: ["eco", "balance", "bolt"]
    property list<string> profiles: ["power-saver", "balanced", "performance"]
    property string currentProfile: ""
    property string currentIcon: "eco"


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
            root.currentIcon = icons[1]
        }else if (root.currentProfile == profiles[1]) {
            setperformance.running=true
            root.currentIcon = icons[2]
        }else if (root.currentProfile == profiles[2]) {
            seteco.running=true
            root.currentIcon = icons[0]
        }else{
            ToastService.showError("shit dont work")
        }
        // ToastService.showInfo("Changed to " + root.currentProfile)
    }

    verticalBarPill: Component {
        DankIcon{
            name: root.currentIcon
            size: Theme.fontSizeLarge
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    root.cycleProfiles()
                }
            }
        }
    }
    horizontalBarPill: Component {
        DankIcon{
            name: root.currentIcon
            size: Theme.fontSizeLarge
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    root.cycleProfiles()
                    ToastService.showInfo("Changed to" + root.currentProfile)
                }
            }
        }
    }

}