import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 1.5
import Qt.labs.qmlmodels 1.0
import assets 1.0

Item {
    property string pageName: "home_page"
    Rectangle {
        id: historyRecord
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
                id: homeTabBar
                height: 30
                width: 360

                anchors {
                    top: parent.top
                    left: parent.left
                }

                TabButton {
                    height: 30
                    text: qsTr("酒店搜索")
                    font {
                        family: Style.fontAwesome
                        bold: false
                        pointSize: 12
                    }

                    anchors {
                        top: parent.top
                    }
                    background: Rectangle {
                        color: homeTabBar.currentIndex == 0 ? "white" : "mediumslateblue"
                    }
                }

                TabButton {
                    height: 30
                    text: qsTr("关联订单")
                    // font: QFont(20)
                    font {
                        family: Style.fontAwesome
                        bold: true
                        pointSize: 12
                    }

                    anchors {
                        top: parent.top
                    }
                    background: Rectangle {
                        color: homeTabBar.currentIndex == 1 ? "white" : "mediumslateblue"
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
            currentIndex: homeTabBar.currentIndex

            HotelSearchItem {}
            MachineRecordsItem {}
            // flow edit page
            Item {
                Rectangle {
                    anchors.fill: parent
                    color: "blue" 
                }
            }
        }
    }
}