function showMessageBox(message, title) {
    let component = Qt.createComponent("./MessageDialog.qml")
    if (component.status === Component.Ready) {
        let dialog = component.createObject(dataInputItem)
        dialog.title = qsTr(title)
        dialog.text = message
        dialog.anchors.centerIn = dataInputItem
        dialog.open()
    } else {
        console.error(component.errorString())
    }
}