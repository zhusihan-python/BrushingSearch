import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Layouts 1.5
import Qt.labs.qmlmodels 1.0
import assets 1.0
import "../components"

Item {
    Rectangle {
        id: machinePageItem
        anchors.fill: parent
        color: "#e6eef6"

        Row {
            id: machinePageFilter
            height: 25
            spacing: 15

            anchors {
                top: parent.top
                topMargin: 10
                left: parent.left
                leftMargin: 10
            }

            TextField {
                id: machineName
                width: 200
                height: 25
                selectByMouse: true

                property int lengthLimit: 25
                background: Rectangle {
                    implicitWidth: 150; implicitHeight: 30
                    color: machineName.enabled ? "white": "transparent"

                    border {
                        color: machineName.focus ? "#21be2b": "grey"
                    }
                }

                onTextChanged: {
                    // 模糊搜索逻辑
                    if (length > lengthLimit) remove(lengthLimit, length);
                    // machineNameTxt.listModel.clear();
                    machineProxyModel.set_name_role();
                    machineProxyModel.setFilterFixedString(text);
                }
            }

            CustomButton {
                id: machineSearch
                text: qsTr("查询")
                colorPressed: "#55aaff"
                colorMouseOver: "#40405f"
                colorDefault: "#33334c"

                width: 100
                height: 25
            }

            CustomButton {
                id: machineAdd
                text: qsTr("新增")
                colorPressed: "#55aaff"
                colorMouseOver: "#40405f"
                colorDefault: "#33334c"

                width: 100
                height: 25
                onClicked: {
                    let popupComponent = Qt.createComponent("newMachinePop.qml");
                    if( popupComponent.status != Component.Ready ) {
                        if( popupComponent.status == Component.Error )
                            console.debug("Error:"+ popupComponent.errorString() );
                            return;
                    } else {
                        let newPopup = popupComponent.createObject(machinePageItem);
                        newPopup.open();
                    }
                }
            }

            CustomButton {
                id: machineDel
                text: qsTr("删除")
                colorPressed: "#55aaff"
                colorMouseOver: "#40405f"
                colorDefault: "#33334c"

                width: 100
                height: 25
                onClicked: {
                    if (machine_table_view.rows > 0) {
                        let popupComponent = Qt.createComponent("delMachinePop.qml");
                        if( popupComponent.status != Component.Ready ) {
                            if( popupComponent.status == Component.Error )
                                console.debug("Error:"+ popupComponent.errorString());
                                return;
                        } else {
                            let delPopup = popupComponent.createObject(machinePageItem);
                            delPopup.cur_name = machineModel.get_name(machine_table_view.selectedRow);
                            delPopup.open();
                        }
                    }
                }
            }
        }

        Rectangle {
            id: machineTableArea
            anchors {
                top: machinePageFilter.bottom
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
            property variant columnWidthArr: [machineTableArea.width/7, machineTableArea.width/7, 
                                                machineTableArea.width/7, machineTableArea.width/7, 
                                                machineTableArea.width/7, machineTableArea.width/7, 
                                                machineTableArea.width/7]

            TableView {
                id: machine_table_view
                anchors {
                    fill: parent
                    leftMargin: machineTableArea.verHeaderWidth
                    topMargin: machineTableArea.horHeaderHeight
                    bottomMargin: 1
                }

                clip: true
                boundsBehavior: Flickable.StopAtBounds
                columnSpacing: 0
                rowSpacing: 0

                property int selectedRow: 0

                rowHeightProvider: function (row) {
                    return machineTableArea.verHeaderHeight;
                }

                columnWidthProvider: function (column) {
                    return machineTableArea.columnWidthArr[column];
                }

                model: machineProxyModel

                delegate: DelegateChooser {
                    DelegateChoice {
                        delegate: Rectangle {
                                color: (model.row === machine_table_view.selectedRow) ? "lightsteelblue" : 
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
                                        machine_table_view.selectedRow = row;
                                    }
                                }
                            }
                        }
                }
            }

            Rectangle {
                width: machineTableArea.verHeaderWidth
                height: machineTableArea.verHeaderHeight
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
                id: machine_header_horizontal

                anchors{
                    left: parent.left
                    right: parent.right
                    leftMargin: machineTableArea.verHeaderWidth
                }
                height: machineTableArea.horHeaderHeight
                z: 2
                //暂存鼠标拖动的位置
                property int posXTemp: 0
                MouseArea{
                    anchors.fill: parent
                    onPressed: machine_header_horizontal.posXTemp=mouseX;
                    onPositionChanged: {
                        if (machine_table_view.contentX + (machine_header_horizontal.posXTemp-mouseX)>0) {
                            machine_table_view.contentX += (machine_header_horizontal.posXTemp-mouseX);
                        } else {
                            machine_table_view.contentX=0;
                        }
                        machine_header_horizontal.posXTemp=mouseX;
                    }
                }

                Row {
                    id: machine_header_horizontal_row
                    anchors.fill: parent
                    leftPadding: -machine_table_view.contentX
                    clip: true
                    spacing: 0
        
                    Repeater {
                        model: machine_table_view.columns > 0 ? machine_table_view.columns : 0
        
                        Rectangle {
                            id: rect_machine_header_horizontal
                            width: machine_table_view.columnWidthProvider(index)+machine_table_view.columnSpacing
                            height: machineTableArea.horHeaderHeight

                            Rectangle {
                                id: headerItemBg
                                height: machineTableArea.horHeaderHeight
                                anchors.fill: parent

                                Canvas {
                                    implicitWidth: rect_machine_header_horizontal.width;
                                    implicitHeight: machineTableArea.horHeaderHeight;
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
                                text: machineModel.headerData(index, Qt.Horizontal)
                            }

                            MouseArea {
                                width: 3
                                height: parent.height
                                anchors.right: parent.right
                                cursorShape: Qt.SplitHCursor
                                onPressed: machine_header_horizontal.posXTemp=mouseX;
                                onPositionChanged: {
                                    if((rect_machine_header_horizontal.width-(machine_header_horizontal.posXTemp-mouseX))>10){
                                        rect_machine_header_horizontal.width-=(machine_header_horizontal.posXTemp-mouseX);
                                    }else{
                                        rect_machine_header_horizontal.width=10;
                                    }
                                    machine_header_horizontal.posXTemp=mouseX;
                                    machineTableArea.columnWidthArr[index]=(rect_machine_header_horizontal.width-machine_table_view.columnSpacing);
                                    //刷新布局，这样宽度才会改变
                                    machine_table_view.forceLayout();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}