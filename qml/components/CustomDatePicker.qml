
import QtQuick 2.15
import QtQuick.Controls 2.15
 
//日期范围选择
Rectangle {
    id:control
    implicitWidth: 250
    implicitHeight: 25
 
    property var beginDate //起始时间
    // property var endDate //截止时间
    property bool __selectedBegin: true //当前选中的是起始时间吗
    property date __minDate  //最小可选时间
    property date __maxDate  //最大可选时间
 
    property color normalTextColor: "#3D3E40"
    property color unselectTextColor: normalTextColor
    property color selectTextColor: "#305FDE"
 
    property alias dateText: itemText.text
 
    radius: 4
    border.color: "#D8DCE6"
 
    //起始日期
    Text {
        id: itemText
        anchors{
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
        }
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
 
        text: beginDate ? Qt.formatDate(beginDate,"yyyy-MM-dd") : ""
        color:!item_pop.visible
              ?normalTextColor
              :__selectedBegin
                ?selectTextColor
                :unselectTextColor
 
        MouseArea{
            anchors.fill: parent
            onClicked: {
                __selectedBegin=true;
                item_pop.open();
            }
        }
    }
 
    Popup {
        id:item_pop
        width: 300
        height: 300
        y:control.height+1

        background: CustomCalendar {
            id:item_calendar
        }

        Connections {
            target: item_calendar
            function onOk() {
                let date = item_calendar.getCurrentDate();
                date.setHours(8);
                dateText = date.toJSON().substring(0, 10);
                item_pop.close();
            }
            function onCancel() {
                item_pop.close();
            }
        }
    }

    function clear() {
        beginDate=undefined;
        // endDate=undefined;
    }
}