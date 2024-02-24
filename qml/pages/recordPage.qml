import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Layouts 1.5
import Qt.labs.qmlmodels 1.0
import assets 1.0

Item {
    property string pageName: "record_page"
    Rectangle {
        id: recordEditPage
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

            TabBar {
                id: recordTabBar
                height: 30
                width: 120

                anchors {
                    top: parent.top
                    left: parent.left
                }

                TabButton {
                    height: 30
                    text: qsTr("数据录入")
                    font {
                        family: Style.fontAwesome
                        bold: false
                        pointSize: 12
                    }

                    anchors {
                        top: parent.top
                    }
                    background: Rectangle {
                        color: recordTabBar.currentIndex == 0 ? "white" : "mediumslateblue"
                    }
                }
            }
        }

        StackLayout {
            width: parent.width

            anchors {
                top: barBg.bottom
                bottom: parent.bottom
            }
            currentIndex: recordTabBar.currentIndex

            RecordPageItem {}
            Item {
                Rectangle {
                    anchors.fill: parent
                    color: "blue"
                }
            }
        }
    }
}