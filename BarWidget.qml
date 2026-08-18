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
    property string changeProfileTo: profiles[(profiles.indexOf(currentProfile)+1)%3]
    
    Process {
        id: getprofile
        command:["powerprofilesctl", "get" ]
        stdout: StdioCollector {
            onStreamFinished: root.currentProfile=text.trim()
        }
    }
    Process {
        id: changeprofile
        command:["powerprofilesctl", "set", root.changeProfileTo ]
        stdout: StdioCollector {
            onStreamFinished: root.currentProfile=root.changeProfileTo
        }
    }

    
    Component.onCompleted: {
        getprofile.running=true
    }


    function cycleProfiles(){
        changeprofile.running=true
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