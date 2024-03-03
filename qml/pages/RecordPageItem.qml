import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Layouts 1.5
import Qt.labs.qmlmodels 1.0
import assets 1.0
import "../components"

Item {
    property int machine_id: -1
    Rectangle {
        id: dataInputItem
        anchors.fill: parent
        color: "#e6eef6"

        Row {
            id: dataInputFilter
            height: 25
            spacing: 15

            anchors {
                top: parent.top
                topMargin: 10
                left: parent.left
                leftMargin: 10
            }

            TextField {
                id: machineNameTxt
                width: 200
                height: 25
                selectByMouse: true

                property int lengthLimit: 25
                property var listModel: ListModel {} // 数据模型
                background: Rectangle {
                    implicitWidth: 150; implicitHeight: 30
                    color: machineNameTxt.enabled ? "white": "transparent"

                    border {
                        color: machineNameTxt.focus ? "#21be2b": "grey"
                    }
                }

                onTextChanged: {
                    // 模糊搜索逻辑
                    if (length > lengthLimit) remove(lengthLimit, length);
                    if (text) {
                        // 从数据源搜索过滤结果到listModel
                        machineCombo.init_data(text);
                        machine_item_pop.open();
                    }
                }

                Popup {
                    id: machine_item_pop
                    y: machineNameTxt.height
                    width: machineNameTxt.width
                    height: 160
                    signal machineSelected(int index)

                    ListView {
                        id: hotelLView
                        model: machineCombo
                        height: 150
                        width: 190
                        
                        delegate: ItemDelegate {
                                    width: 190
                                    height: 20
                                    text: model.display
                                    background: Rectangle {
                                        width: 180
                                        radius: 5
                                        color: {
                                            if (parent.hovered)
                                                return "lightsteelblue";
                                            return "white";
                                        }
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            machine_item_pop.close();
                                            machineNameText.text = model.display;
                                            machine_item_pop.machineSelected(index);
                                        }
                                    }
                                }
                        focus: true
                        keyNavigationWraps: true
                        ScrollBar.vertical: ScrollBar {
                            id: machineScroll
                            size: 0.3
                            width: 10
                            policy: ScrollBar.AlwaysOn

                            contentItem: Rectangle {
                                implicitWidth: 3
                                implicitHeight: 100
                                radius: width / 2
                                color: machineScroll.pressed ? "darkgrey" : "lightgrey"
                                opacity: machineScroll.policy === ScrollBar.AlwaysOn || (machineScroll.active && machineScroll.size < 1.0) ? 0.75 : 0
                            }
                        }
                    }
                }
            }

            Label {
                id: machineLabel
                width: 60
                height: 25
                text: "机器编号："
                font.bold: true
                font.pointSize: 10
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                id: machineNameText
                text: ""
                width: 150
                height: 25
                font.pointSize: 10
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                id: paltformLabelTwo
                width: 60
                height: 25
                text: "APP平台："
                font.bold: true
                font.pointSize: 10
                verticalAlignment: Text.AlignVCenter
            }

            ComboBox {
                id: paltformSelectorTwo
                width: 150
                height: 25
                model: platformCombo
                textRole: "display"
            }
        }

        Rectangle {
            id: dataEditArea
            anchors {
                top: dataInputFilter.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                margins: 5
            }
            border {
                color: "grey"
                width: 1
            }
        }
    }
    Connections {
        target: machine_item_pop

        function onMachineSelected(index) {
            machine_id = machineCombo.get_machine_number(index);
        }
    }
}