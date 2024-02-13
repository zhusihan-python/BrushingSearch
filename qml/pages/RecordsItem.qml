import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Dialogs
import Qt.labs.qmlmodels 1.0
import "../components"

Item {
    property string destination: rFileDialog.selectedFile
    property int export_type: 0
    Rectangle {
        anchors.fill: parent
        color: "#e6eef6"

        Row {
            id: recordFilterRow
            height: 25
            spacing: 15

            anchors {
                top: parent.top
                topMargin: 10
                left: parent.left
                leftMargin: 10
            }

            TextField {
                id: recordIdTextField
                width: 150
                height: 25
                selectByMouse: true
                validator: RegularExpressionValidator { regularExpression: /^[0-9]{1,}$/ }

                property int lengthLimit: 20
                background: Rectangle {
                    implicitWidth: 150; implicitHeight: 30
                    color: recordIdTextField.enabled ? "white": "transparent"

                    border {
                        color: recordIdTextField.focus ? "#21be2b": "grey"
                    }
                }
                onTextChanged: if (length > lengthLimit) remove(lengthLimit, length);
            }

            CustomButton {
                id: rQueryBtn
                text: qsTr("查询")
                colorDefault: Qt.lighter("blue")
                colorPressed: "#55aaff"
                colorMouseOver: "#40405f"
                implicitWidth: 100
                implicitHeight: 25

                onClicked: {

                }
            }

            CustomButton {
                id: rExportBtn
                text: qsTr("导出")
                colorDefault: Qt.lighter("blue")
                colorPressed: "#55aaff"
                colorMouseOver: "#40405f"

                implicitWidth: 100
                implicitHeight: 25

                onClicked: {
                    if ( record_table_view.selectedRows.size > 0 ) {
                        export_type = 0;
                        rFileDialog.open();
                    } else {
                        // MessageBox.showMessageBox("请选择记录", "提示");
                    }
                }
            }

            FileDialog {
                id: rFileDialog
                fileMode: FileDialog.SaveFile
                nameFilters: ["PDF files (*.pdf)"]
                 onAccepted: {
                    // console.log("User has selected " + rFileDialog.selectedFile, destination);
                    rFileDialog.close();
                    pdfWriter.write_to_file_path(destination.toString(), [...record_table_view.selectedRows], export_type);
                }
            }
        }

        Rectangle {
            id: recordTable
            width: 1720
            // height: 780
            border {
                color: "grey"
                width: 1
            }

            property int verHeaderHeight: 20
            property int verHeaderWidth: 50
            property int horHeaderHeight: 20
            property int horHeaderWidth: 30
            property color scrollBarColor: Qt.lighter("grey")
            property int scrollBarWidth: 6
            // property int finished: 0
            property variant columnWidthArr: [150, 150, 360, 150, 160, 160, 150, 360]

            anchors {
                // bottom: parent.bottom
                top: recordFilterRow.bottom
                topMargin: 10
                bottom: parent.bottom
                bottomMargin: 15
                left: parent.left
                leftMargin: 10
            }

            TableView {
                id: record_table_view
                anchors {
                    fill: parent
                    leftMargin: recordTable.verHeaderWidth
                    topMargin: recordTable.horHeaderHeight
                    bottomMargin: 1
                }

                clip: true
                boundsBehavior: Flickable.StopAtBounds
                columnSpacing: 0
                rowSpacing: 0

                property var selectedRows: new Set()

                rowHeightProvider: function (row) {
                    return recordTable.verHeaderHeight;
                }

                columnWidthProvider: function (column) {
                    return recordTable.columnWidthArr[column];
                }

                model: machineModel

                delegate: DelegateChooser {
                    DelegateChoice {
                        delegate: Rectangle {
                                color: (model.row %2 ===0) ? "white": "#F6F6F6";

                                Text {
                                    anchors {
                                        centerIn: parent
                                    }
                                    text: display === undefined ? "" : display
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true

                                    onClicked: {}
                                }
                            }
                        }
                }
            }

            Rectangle {
                width: recordTable.verHeaderWidth
                height: recordTable.verHeaderHeight
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

            Column {

                anchors {
                    top: parent.top
                    topMargin: recordTable.verHeaderHeight
                    bottom: parent.bottom
                    bottomMargin: 1
                }
                topPadding: -record_table_view.contentY
                z: 2
                clip: true
                // spacing: 1
            }

            // horizon header
            Item {
                id: rHeader_horizontal

                anchors{
                    left: parent.left
                    right: parent.right
                    leftMargin: recordTable.verHeaderWidth
                }
                height: recordTable.horHeaderHeight
                z: 2
                //暂存鼠标拖动的位置
                property int posXTemp: 0
                MouseArea{
                    anchors.fill: parent
                    onPressed: rHeader_horizontal.posXTemp=mouseX;
                    onPositionChanged: {
                        if (record_table_view.contentX + (rHeader_horizontal.posXTemp-mouseX)>0) {
                            record_table_view.contentX += (rHeader_horizontal.posXTemp-mouseX);
                        } else {
                            record_table_view.contentX=0;
                        }
                        rHeader_horizontal.posXTemp=mouseX;
                    }
                }

                Row {
                    id: header_horizontal_row
                    anchors.fill: parent
                    leftPadding: -record_table_view.contentX
                    clip: true
                    spacing: 0

                    Repeater {
                        model: record_table_view.columns > 0 ? record_table_view.columns : 0

                        Rectangle {
                            id: reagent_header_horizontal
                            width: record_table_view.columnWidthProvider(index)+record_table_view.columnSpacing
                            height: recordTable.horHeaderHeight

                            Rectangle {
                                id: headerItemBg
                                height: recordTable.horHeaderHeight
                                anchors.fill: parent

                                Canvas {
                                    implicitWidth: reagent_header_horizontal.width;
                                    implicitHeight: recordTable.horHeaderHeight;
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
                                onPressed: rHeader_horizontal.posXTemp=mouseX;
                                onPositionChanged: {
                                    if((reagent_header_horizontal.width-(rHeader_horizontal.posXTemp-mouseX))>10){
                                        reagent_header_horizontal.width-=(rHeader_horizontal.posXTemp-mouseX);
                                    }else{
                                        reagent_header_horizontal.width=10;
                                    }
                                    rHeader_horizontal.posXTemp=mouseX;
                                    recordTable.columnWidthArr[index]=(reagent_header_horizontal.width-record_table_view.columnSpacing);
                                    //刷新布局，这样宽度才会改变
                                    record_table_view.forceLayout();
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
    }
}