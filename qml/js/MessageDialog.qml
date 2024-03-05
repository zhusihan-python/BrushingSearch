import QtQuick
import QtQuick.Controls
import "../components"

Popup {
    id: messagePopup
    modal: true
    focus: true
    padding: 0
    width: 520
    height: 320

    background: Rectangle {
        // id: newSlidePopupBackground
        color: "transparent"
        radius: 15
    }
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property alias title: topBarTitle.text
    property alias text : textContainer.text

    contentItem: Rectangle {
        color: "transparent"
        radius: 15
        Drag.active: true
        MouseArea{
            anchors.fill: parent
            drag.target: parent
        }

        Rectangle {
            // id: messageBoxDisplay
            radius: 15

            anchors.fill: parent

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

            border.width:           1
            border.color:           "paleturquoise"

            Rectangle {
                // id: messageTopBar
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
                    source: "../../images/images/tips.png"
                }

                Label {
                    id: topBarTitle
                    width: 40
                    height: 16
                    text: "提示"
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
                    btnIconSource: "../../images/svg_images/close_icon.svg"

                    anchors {
                        top: parent.top
                        right: parent.right
                    }
                    onClicked: messagePopup.close()
                }
            }

            Text {
                id: textContainer
                width: 400
                wrapMode: Text.WordWrap

                font {
                    family: "Helvetica"
                    bold: false
                    pointSize: 12
                }

                anchors.centerIn: parent

                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignTop
            }
        }
    }
}