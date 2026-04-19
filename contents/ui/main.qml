import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.ksysguard.sensors as Sensors
import org.kde.plasma.plasma5support as P5Support


PlasmoidItem {
    id: root
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    preferredRepresentation: fullRepresentation

    property int batteryPercent: 0

    P5Support.DataSource {
        id: pmSource
        engine: "powermanagement"
        connectedSources: ["Battery"]
        interval: 5000

        onNewData: function(source, data) {
            if (source === "Battery") {
                root.batteryPercent = data["Percent"] || 0;
            }
        }
    }

    fullRepresentation: Item {
        id: container
        Layout.preferredWidth: 420
        Layout.preferredHeight: 230
        width: Layout.preferredWidth
        height: Layout.preferredHeight
        clip: true

        readonly property string fontFam: "Hack"
        readonly property string accentColor: "#ffffff"
        readonly property string dimColor: "#888888"

        property int tick: 0
        property string spinner: "\\"
        property string hexStream: "00 00 00 00"
        property string podProgram: "A140: GRAVITY"
        property real signalStrength: 98.2
        property real bbSync: 99.9

        property real pulseOpacity: 1.0
        SequentialAnimation on pulseOpacity {
            loops: Animation.Infinite
            NumberAnimation { to: 0.2; duration: 800; easing.type: Easing.InOutSine }
            NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutSine }
        }

        Sensors.Sensor { id: cpuSensor; sensorId: "cpu/all/usage" }
        Sensors.Sensor { id: ramUsed; sensorId: "memory/physical/used" }
        Sensors.Sensor { id: ramTotal; sensorId: "memory/physical/total" }
        Sensors.Sensor { id: gpuSensor; sensorId: "gpu/all/usage" }
        //=======================================FUCK VRAM=====================================
        Sensors.Sensor { id: g0u; sensorId: "gpu/gpu0/usedVram" }
        Sensors.Sensor { id: g0t; sensorId: "gpu/gpu0/totalVram" }
        Sensors.Sensor { id: g1u; sensorId: "gpu/gpu1/usedVram" }
        Sensors.Sensor { id: g1t; sensorId: "gpu/gpu1/totalVram" }
        Sensors.Sensor { id: g2u; sensorId: "gpu/gpu2/usedVram" }
        Sensors.Sensor { id: g2t; sensorId: "gpu/gpu2/totalVram" }
        Sensors.Sensor { id: g3u; sensorId: "gpu/gpu3/usedVram" }
        Sensors.Sensor { id: g3t; sensorId: "gpu/gpu3/totalVram" }

        property real realCpu: cpuSensor.value || 0
        property real realRam: (ramTotal.value > 0) ? (ramUsed.value / ramTotal.value * 100) : 0
        property real realGpu: gpuSensor.value || 0
        property real realVram: {
            let used = (g0u.value || 0) + (g1u.value || 0) + (g2u.value || 0) + (g3u.value || 0);
            let total = (g0t.value || 0) + (g1t.value || 0) + (g2t.value || 0) + (g3t.value || 0);
            return (total > 0) ? (used / total * 100) : 0;
        }

        function getBar(val) {
            let res = "[";
            let filled = Math.floor(val / (100/14));
            filled = Math.max(0, Math.min(14, filled));
            for(let i=0; i<14; i++) res += (i < filled) ? "|" : ".";
            return res + "]";
        }

        function padNum(val) {
            let s = Math.round(val).toString();
            if(s.length === 1) return "  " + s;
            if(s.length === 2) return " " + s;
            return s;
        }

        Timer {
            interval: 60
            running: true
            repeat: true
            onTriggered: {
                tick++
                let s = ["\\", "|", "/", "-"];
                spinner = s[tick % 4];

                let chars = "0123456789ABCDEF";
                let h = "";
                for(let i=0; i<6; i++) {
                    h += chars.charAt(Math.floor(Math.random()*16)) + chars.charAt(Math.floor(Math.random()*16)) + " ";
                }
                hexStream = h;

                if (tick % 100 === 0) {
                    let progs = ["A140: GRAVITY", "R010: LASER", "A060: P-SHIELD", "R050: SPEAR"];
                    podProgram = progs[Math.floor(Math.random() * progs.length)];
                }

                // Динамические метрики
                signalStrength = 98 + (Math.random() * 1.5);
                bbSync = 98.5 + (Math.random() * 1.4);
            }
        }

        Rectangle {
            width: parent.width; height: 1; color: accentColor; opacity: 0.1
            NumberAnimation on y { from: 0; to: 230; duration: 4000; loops: Animation.Infinite }
        }

        Column {
            anchors.centerIn: parent
            width: 380
            spacing: 1

            // ================= Decoration =================
            RowLayout {
                width: parent.width

                Column {
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    spacing: 1
                    Text { text: "BUNKER_LINK : ESTABLISHED [ " + spinner + " ]"; color: accentColor; font.family: fontFam; font.pixelSize: 10; font.bold: true }
                    Text { text: "SIGNAL_STR  : " + signalStrength.toFixed(1) + "%"; color: accentColor; font.family: fontFam; font.pixelSize: 10 }
                }

                Item { Layout.fillWidth: true }

                Column {
                    Layout.alignment: Qt.AlignTop | Qt.AlignRight
                    spacing: 1
                    Text { text: "UNIT_ID   : 2B_MODEL_S"; color: accentColor; font.family: fontFam; font.pixelSize: 10 }
                    Text { text: "POD_PROG  : " + podProgram; color: accentColor; font.family: fontFam; font.pixelSize: 10 }
                    Text { text: "STATUS    : ANALYZING..."; color: dimColor; font.family: fontFam; font.pixelSize: 10 }
                }
            }

            Item { width: 1; height: 8 }
            Text { text: "-------------------------------------------------------------"; color: "#444444"; font.family: fontFam; font.pixelSize: 10 }
            Item { width: 1; height: 8 }

            // ================= SYSTEM MONITOR =================
            RowLayout {
                width: parent.width

                Column {
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    spacing: 1
                    Row {
                        spacing: 0
                        Text { text: "CPU_LOAD : "; color: accentColor; font.family: fontFam; font.pixelSize: 10 }
                        Text { text: getBar(realCpu) + " "; color: accentColor; font.family: fontFam; font.pixelSize: 10; opacity: pulseOpacity }
                        Text { text: padNum(realCpu); color: accentColor; font.family: fontFam; font.pixelSize: 10 }
                        Text { text: "%"; color: accentColor; font.family: fontFam; font.pixelSize: 10; opacity: pulseOpacity }
                    }
                    Row {
                        spacing: 0
                        Text { text: "RAM_USE  : "; color: accentColor; font.family: fontFam; font.pixelSize: 10 }
                        Text { text: getBar(realRam) + " "; color: accentColor; font.family: fontFam; font.pixelSize: 10; opacity: pulseOpacity }
                        Text { text: padNum(realRam); color: accentColor; font.family: fontFam; font.pixelSize: 10 }
                        Text { text: "%"; color: accentColor; font.family: fontFam; font.pixelSize: 10; opacity: pulseOpacity }
                    }
                }

                Item { Layout.fillWidth: true }

                Column {
                    Layout.alignment: Qt.AlignTop | Qt.AlignRight
                    spacing: 1
                    Row {
                        spacing: 0
                        Text {
                            text: (root.batteryPercent > 0) ? "BATTERY  : " : "VRAM_USED: "
                            color: accentColor; font.family: fontFam; font.pixelSize: 10
                        }
                        Text {
                            property real val: (root.batteryPercent > 0) ? root.batteryPercent : realVram
                            text: getBar(val) + " "
                            color: accentColor; font.family: fontFam; font.pixelSize: 10; opacity: pulseOpacity
                        }
                        Text {
                            text: (root.batteryPercent > 0) ? padNum(root.batteryPercent) : padNum(realVram)
                            color: accentColor; font.family: fontFam; font.pixelSize: 10
                        }
                        Text {
                            text: "%"
                            color: accentColor; font.family: fontFam; font.pixelSize: 10; opacity: pulseOpacity
                        }
                    }
                    Row {
                        spacing: 0
                        Text { text: "GPU_LOAD : "; color: accentColor; font.family: fontFam; font.pixelSize: 10 }
                        Text { text: getBar(realGpu) + " "; color: accentColor; font.family: fontFam; font.pixelSize: 10; opacity: pulseOpacity }
                        Text { text: padNum(realGpu); color: accentColor; font.family: fontFam; font.pixelSize: 10 }
                        Text { text: "%"; color: accentColor; font.family: fontFam; font.pixelSize: 10; opacity: pulseOpacity }
                    }
                }
            }

            Item { width: 1; height: 8 }
            Text { text: "-------------------------------------------------------------"; color: "#444444"; font.family: fontFam; font.pixelSize: 10 }
            Item { width: 1; height: 8 }

            // ================= DECORATION =================
            RowLayout {
                width: parent.width

                Column {
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    spacing: 1
                    Text { text: "> DEPLOYING_WIDE_HUD_MATRIX..."; color: dimColor; font.family: fontFam; font.pixelSize: 9 }
                    Text { text: "> MEM_STREAM: " + hexStream; color: dimColor; font.family: fontFam; font.pixelSize: 9 }
                    Text { text: "> NO_ERRORS_DETECTED"; color: dimColor; font.family: fontFam; font.pixelSize: 9 }
                }

                Item { Layout.fillWidth: true }

                Column {
                    Layout.alignment: Qt.AlignTop | Qt.AlignRight
                    spacing: 1
                    Row {
                        spacing: 0
                        Text { text: "BLACK_BOX_SYNC : "; color: dimColor; font.family: fontFam; font.pixelSize: 9 }
                        Text { text: bbSync.toFixed(1) + "%"; color: accentColor; font.family: fontFam; font.pixelSize: 9; opacity: pulseOpacity }
                    }
                    Text { text: "LOGICAL_VIRUS  : CLEAR"; color: dimColor; font.family: fontFam; font.pixelSize: 9 }
                    Text { text: "RELAY_STATION  : ORBITAL"; color: dimColor; font.family: fontFam; font.pixelSize: 9 }
                }
            }

            Item { width: 1; height: 8 }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: (Math.random() > 0.97) ? "[ CRITICAL_CHECK_REQUIRED ]" : "[ ALL_SYSTEMS_NOMINAL ]"
                color: accentColor
                font.family: fontFam
                font.pixelSize: 10
                font.bold: true
                opacity: (text[1] === 'C') ? 0.5 : 1.0
            }
        }
    }
}
