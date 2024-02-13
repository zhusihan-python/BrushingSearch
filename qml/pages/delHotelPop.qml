import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Layouts 1.5
import "../components"
import "../js/messageBox.js" as MessageBox

Popup {
    id: delHotelPop
    modal: true
    focus: true
    padding: 0
    width: 540
    height: 400
    background: Rectangle {
        color: "transparent"
        radius: 15
    }
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property string cur_name: ""

    contentItem: Rectangle{
        color: "transparent"
        radius: 15
        Drag.active: true
        MouseArea{
            anchors.fill: parent
            drag.target: parent
        }

        Rectangle {
            id: display1
            radius: 15

            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: "silver"
                }
                GradientStop {
                    position: 1.0
                    color: "slategray"
                }
            }

            border.width: 1
            border.color: "paleturquoise"

            anchors {
                fill: parent
            }

            Rectangle {
                id: topBar
                // radius: 15
                height: 30
                color: "transparent"

                Canvas {
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.reset();

                        var centreX = width / 2;
                        var centreY = height / 2;

                        ctx.beginPath();
                        ctx.fillStyle =  Qt.lighter("blue");
                        ctx.moveTo(centreY, centreY);
                        ctx.arc(centreY, centreY, centreY, -Math.PI, -Math.PI* 0.5, false);
                        ctx.lineTo(centreY, 0);
                        ctx.lineTo(width-centreY, 0);
                        ctx.lineTo(width-centreY, centreY);
                        ctx.arc(width-centreY, centreY, centreY, -Math.PI* 0.5, 0, false);
                        ctx.lineTo(width, height);
                        ctx.lineTo(0, height);
                        ctx.lineTo(0, centreY);
                        ctx.fill();
                        ctx.closePath();
                    }
                }
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                Image {
                    id: topBarIcon
                    width: 16
                    height: 16
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: 5
                    }
                    source: "../images/svg_images/user_icon.svg"
                }

                Label {
                    id: topBarTitle
                    width: 40
                    height: 16
                    text: "删除酒店"
                    anchors {
                        left: topBarIcon.right
                        leftMargin: 5
                        verticalCenter: parent.verticalCenter
                    }
                    font.bold: true
                    font.pointSize: 12
                    color: "white"
                }

                TopBarButton {
                    id: btnClose
                    width: 30
                    height: 30
                    btnColorDefault: "transparent"
                    btnColorClicked: "#ff007f"
                    btnIconSource: "../images/svg_images/close_icon.svg"

                    anchors {
                        top: parent.top
                        right: parent.right
                    }
                    onClicked: delHotelPop.close()
                }
            }

            Text {
                id: delConfrimMessage
                text: "是否确定删除酒店" + cur_name + "?"
                font.pointSize: 14
                font.bold: true
                anchors {
                    centerIn: parent
                }
            }

            Rectangle {
                // id: delUserBtnRow
                width: 300
                height: 35
                color: "transparent"

                anchors {
                    bottom: parent.bottom
                    bottomMargin: 25
                    horizontalCenter: parent.horizontalCenter
                }

                Row {
                    spacing: 50
                    anchors.centerIn: parent

                    CustomButton {
                        id: confirmBtn
                        text: qsTr("确定")
                        width: 100
                        height: 30
                        colorDefault: Qt.lighter("blue")
                        colorPressed: "#55aaff"
                        colorMouseOver: "#40405f"

                        onClicked: {
                            delHotel();
                            delHotelPop.close();
                        }
                    }

                    CustomButton {
                        id: cancelBtn
                        text: qsTr("取消")
                        width: 100
                        height: 30
                        colorDefault: Qt.lighter("blue")
                        colorPressed: "#55aaff"
                        colorMouseOver: "#40405f"

                        onClicked: {
                            delHotelPop.close();
                        }
                    }
                }
            }
        }
    }

    function delHotel() {
        hotelModel.del_hotel(hotel_table_view.selectedRow);
        hotelModel.init_data();
    }

    anchors {
        centerIn: parent
    }
}