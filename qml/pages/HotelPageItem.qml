import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Layouts 1.5
import Qt.labs.qmlmodels 1.0
import assets 1.0
import "../components"

Item {
    Rectangle {
        id: hotelItem
        anchors.fill: parent
        color: "#e6eef6"

        Row {
            id: hotelPageFilter
            height: 25
            spacing: 15

            anchors {
                top: parent.top
                topMargin: 10
                left: parent.left
                leftMargin: 10
            }

            TextField {
                id: hotelName
                width: 200
                height: 25
                selectByMouse: true

                property int lengthLimit: 25
                background: Rectangle {
                    implicitWidth: 150; implicitHeight: 30
                    color: hotelName.enabled ? "white": "transparent"

                    border {
                        color: hotelName.focus ? "#21be2b": "grey"
                    }
                }

                onTextChanged: {
                    // 模糊搜索逻辑
                    if (length > lengthLimit) remove(lengthLimit, length);
                    // hotelNameTxt.listModel.clear();
                    hotelProxyModel.set_name_role();
                    hotelProxyModel.setFilterFixedString(text);
                }
            }

            CustomButton {
                id: hotelSearch
                text: qsTr("查询")
                colorPressed: "#55aaff"
                colorMouseOver: "#40405f"
                colorDefault: "#33334c"

                width: 100
                height: 25
            }

            CustomButton {
                id: hotelAdd
                text: qsTr("新增")
                colorPressed: "#55aaff"
                colorMouseOver: "#40405f"
                colorDefault: "#33334c"

                width: 100
                height: 25
                onClicked: {
                    let popupComponent = Qt.createComponent("newHotelPop.qml")
                    if( popupComponent.status != Component.Ready ) {
                        if( popupComponent.status == Component.Error )
                            console.debug("Error:"+ popupComponent.errorString() );
                            return;
                    } else {
                        let newPopup = popupComponent.createObject(hotelItem);
                        newPopup.open()
                    }
                }
            }

            CustomButton {
                id: hotelDel
                text: qsTr("删除")
                colorPressed: "#55aaff"
                colorMouseOver: "#40405f"
                colorDefault: "#33334c"

                width: 100
                height: 25
                onClicked: {
                    if (hotel_table_view.rows > 0) {
                        let popupComponent = Qt.createComponent("delHotelPop.qml");
                        if( popupComponent.status != Component.Ready ) {
                            if( popupComponent.status == Component.Error )
                                console.debug("Error:"+ popupComponent.errorString());
                                return;
                        } else {
                            let delPopup = popupComponent.createObject(hotelItem);
                            delPopup.cur_name = hotelModel.get_name(hotel_table_view.selectedRow);
                            delPopup.open();
                        }
                    }
                }
            }
        }

        Rectangle {
            id: hotelTableArea
            anchors {
                top: hotelPageFilter.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                margins: 5
            }
            border {
                color: "grey"
                width: 1
            }

            property int verHeaderHeight: 20
            property int verHeaderWidth: 1
            property int horHeaderHeight: 20
            property int horHeaderWidth: 30
            property color scrollBarColor: Qt.lighter("grey")
            property int scrollBarWidth: 6
            property variant columnWidthArr: [hotelTableArea.width/5, hotelTableArea.width/5, 
                                                hotelTableArea.width/5, hotelTableArea.width/5, 
                                                hotelTableArea.width/5]

            anchors {
                top: hotelPageFilter.bottom
                topMargin: 10
                bottom: parent.bottom
                bottomMargin: 15
                left: parent.left
                leftMargin: 10
            }

            TableView {
                id: hotel_table_view
                anchors {
                    fill: parent
                    leftMargin: hotelTableArea.verHeaderWidth
                    topMargin: hotelTableArea.horHeaderHeight
                    bottomMargin: 1
                }

                clip: true
                boundsBehavior: Flickable.StopAtBounds
                columnSpacing: 0
                rowSpacing: 0

                property int selectedRow: 0

                rowHeightProvider: function (row) {
                    return hotelTableArea.verHeaderHeight;
                }

                columnWidthProvider: function (column) {
                    return hotelTableArea.columnWidthArr[column];
                }

                model: hotelProxyModel

                delegate: DelegateChooser {
                    DelegateChoice {
                        delegate: Rectangle {
                                color: (model.row === hotel_table_view.selectedRow) ? "lightsteelblue" : 
                                    ((model.row %2 ===0) ? "white": "#F6F6F6");

                                Text {
                                    anchors {
                                        centerIn: parent
                                    }
                                    text: display === undefined ? "" : display
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true

                                    onClicked: {
                                        hotel_table_view.selectedRow = row;
                                    }
                                }
                            }
                        }
                }
            }

            Rectangle {
                width: hotelTableArea.verHeaderWidth
                height: hotelTableArea.verHeaderHeight
                color: "#F8F8F8"
                anchors {
                    top: parent.top
                    left: parent.left
                }

                Rectangle {
                    height: 1
                    width: parent.width
                    anchors.bottom: parent.bottom
                    color: "#E5E5E5"
                }
                Rectangle {
                    height: 1
                    width: parent.width
                    anchors.top: parent.top
                    color: "#E5E5E5"
                }
            }

            // horizon header
            Item {
                id: header_horizontal

                anchors{
                    left: parent.left
                    right: parent.right
                    leftMargin: hotelTableArea.verHeaderWidth
                }
                height: hotelTableArea.horHeaderHeight
                z: 2
                //暂存鼠标拖动的位置
                property int posXTemp: 0
                MouseArea{
                    anchors.fill: parent
                    onPressed: header_horizontal.posXTemp=mouseX;
                    onPositionChanged: {
                        if (hotel_table_view.contentX + (header_horizontal.posXTemp-mouseX)>0) {
                            hotel_table_view.contentX += (header_horizontal.posXTemp-mouseX);
                        } else {
                            hotel_table_view.contentX=0;
                        }
                        header_horizontal.posXTemp=mouseX;
                    }
                }

                Row {
                    id: header_horizontal_row
                    anchors.fill: parent
                    leftPadding: -hotel_table_view.contentX
                    clip: true
                    spacing: 0
        
                    Repeater {
                        model: hotel_table_view.columns > 0 ? hotel_table_view.columns : 0
        
                        Rectangle {
                            id: reagent_header_horizontal
                            width: hotel_table_view.columnWidthProvider(index)+hotel_table_view.columnSpacing
                            height: hotelTableArea.horHeaderHeight

                            Rectangle {
                                id: headerItemBg
                                height: hotelTableArea.horHeaderHeight
                                anchors.fill: parent

                                Canvas {
                                    implicitWidth: reagent_header_horizontal.width;
                                    implicitHeight: hotelTableArea.horHeaderHeight;
                                    onPaint: {
                                        var ctx = getContext("2d");
                                        var gradient = ctx.createLinearGradient(0, 0, 0, 32);
                                        gradient.addColorStop(0, "white");
                                        gradient.addColorStop(1, "#0edcfb");
                                        ctx.fillStyle = gradient;
                                        ctx.fillRect(0, 0, width, height);
                                        ctx.strokeStyle = "#D7D7DF";
                                        ctx.lineWidth = 2;
                                        ctx.save();
                                        ctx.beginPath();
                                        ctx.moveTo(0, 1);
                                        ctx.lineTo(canvasSize.width, 1);
                                        ctx.stroke();
                                        ctx.beginPath();
                                        ctx.moveTo(0, canvasSize.height - 1);
                                        ctx.lineTo(canvasSize.width, canvasSize.height - 1);
                                        ctx.stroke();
                                        ctx.font = "12pt sans-serif";
                                        ctx.textAlign = "center";
                                        ctx.fillStyle = "#000000";
                                        ctx.restore();
                                    }
                                }
                            }
        
                            Text {
                                anchors.centerIn: parent
                                text: hotelModel.headerData(index, Qt.Horizontal)
                            }

                            MouseArea {
                                width: 3
                                height: parent.height
                                anchors.right: parent.right
                                cursorShape: Qt.SplitHCursor
                                onPressed: header_horizontal.posXTemp=mouseX;
                                onPositionChanged: {
                                    if((reagent_header_horizontal.width-(header_horizontal.posXTemp-mouseX))>10){
                                        reagent_header_horizontal.width-=(header_horizontal.posXTemp-mouseX);
                                    }else{
                                        reagent_header_horizontal.width=10;
                                    }
                                    header_horizontal.posXTemp=mouseX;
                                    hotelTableArea.columnWidthArr[index]=(reagent_header_horizontal.width-hotel_table_view.columnSpacing);
                                    //刷新布局，这样宽度才会改变
                                    hotel_table_view.forceLayout();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}