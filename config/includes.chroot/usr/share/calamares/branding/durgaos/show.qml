import QtQuick 2.0
import calamares.slideshow 1.0

Presentation {
    id: presentation

    Timer {
        interval: 8000
        running: true
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }

    Slide {
        Text {
            anchors.centerIn: parent
            text: "Welcome to Durga OS\nFast, Secure & Animated Desktop Experience"
            color: "#00E5FF"
            font.pixelSize: 22
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Slide {
        Text {
            anchors.centerIn: parent
            text: "Run Windows .exe & Android APKs\nWine & Waydroid Containers Built-In"
            color: "#FFFFFF"
            font.pixelSize: 20
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Slide {
        Text {
            anchors.centerIn: parent
            text: "Linux-Grade Hardening\nAppArmor Enforcing & UFW Firewall Shield Active"
            color: "#00FFAB"
            font.pixelSize: 20
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
