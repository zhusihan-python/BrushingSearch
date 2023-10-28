import sys
import os

from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine
# from mainWindow import MainWindow

if __name__ == "__main__":
    import os
    os.environ['QML_IMPORT_TRACE'] = '1'
    os.environ['CONFIG'] = 'qml_debug '
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # Get Context
    # main = MainWindow()
    # engine.rootContext().setContextProperty("backend", main)

    # Set App Extra Info
    app.setOrganizationName("Wanderson M. Pimenta")
    app.setOrganizationDomain("N/A")

    # Set Icon
    app.setWindowIcon(QIcon("images/icon.ico"))

    # Load Initial Window
    engine.load(os.path.join(os.path.dirname(__file__), "qml/app.qml"))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())