pragma Singleton
import QtQuick 2.15

Item {
    property alias fontAwesome: fontAwesomeLoader.name
    property alias fontCang: fontCangLoader.name
    FontLoader {
        id: fontAwesomeLoader
        // source: "../fonts/hywbj.ttf"
        source: "../fonts/XiYuan.ttf"
    }
    FontLoader {
        id: fontCangLoader
        source: "../fonts/CangJi.ttf"
    }
}