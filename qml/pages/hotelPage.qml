import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Layouts 1.5
import Qt.labs.qmlmodels 1.0
import assets 1.0

Item {
    property string pageName: "hotel_page"
    Rectangle {
        id: hotelEditPage
        width: 1300
        height: 700
        color: "#e6eef6"

        anchors {
            fill: parent
        }

        Rectangle {
            id: barBg
            width: parent.width
            height: 30
            color: "transparent"

            anchors {
                top: parent.top
            }
        }
    }
}