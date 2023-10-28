from PySide6.QtCore import QAbstractListModel, Qt, QModelIndex, Slot
from need.db.db_model import db_model


class HotelCombo(QAbstractListModel):
    """
    A abstract list model that implements the minimum amount of functions
    neccessary to use the model with a QML QtQuick ComboBox.
    """
    def __init__(self, parent=None):
        super().__init__()
        self.parent = parent
        self.raw_data = []
        self.lst = []

    def init_data(self):
        data = []
        self.raw_data = data
        self.lst = [d[0] for d in data]        
    
    def rowCount(self, idx: QModelIndex=None) -> int:
        return len(self.lst)

    def data(self, index, role=Qt.DisplayRole):
        if not index.isValid():
            return None
        
        if role == Qt.DisplayRole:
            return self.lst[index.row()]
        
        if role == Qt.UserRole:
            return 99
        return

    def insertRow(self, row: int, index: QModelIndex=QModelIndex()) -> bool:
        if row < 0 or row > len(self.lst):
            return False

        self.beginInsertRows(QModelIndex(), row, row+1-1)
        self.lst.insert(row, "Lorem Ipsum")
        self.endInsertRows()
        return True

    def setData(self, index: QModelIndex, value: str, role: int=Qt.DisplayRole) -> bool:
        if index.row() >=0 and index.row() < len(self.lst):
            if not role == Qt.DisplayRole or role == Qt.EditRole:
                return False
            self.lst[index.row()] = value
            self.dataChanged.emit(index, index, [Qt.EditRole | Qt.DisplayRole])
            return True
        return False

    def setNewList(self, lst: list=[]):
        self.beginResetModel()
        self.lst = lst
        self.endResetModel()
        return

    @Slot(int, result=int)
    def get_operator_id(self, index: int) -> int:
        return self.raw_data[index][-1]

hotel_combo = HotelCombo()


class PlatformCombo(QAbstractListModel):
    """
    A abstract list model that implements the minimum amount of functions
    neccessary to use the model with a QML QtQuick ComboBox.
    """
    def __init__(self, parent=None):
        super().__init__()
        self.parent = parent
        self.raw_data = []
        self.lst = []

    def init_data(self):
        self.raw_data = db_model.search_platform()
        self.beginResetModel()
        self.lst = [d[0] for d in self.raw_data]
        self.endResetModel()     
    
    def rowCount(self, idx: QModelIndex=None) -> int:
        return len(self.lst)

    def data(self, index, role=Qt.DisplayRole):
        if not index.isValid():
            return None
        
        if role == Qt.DisplayRole:
            return self.lst[index.row()]
        
        if role == Qt.UserRole:
            return 99
        return

    def setData(self, index: QModelIndex, value: str, role: int=Qt.DisplayRole) -> bool:
        if index.row() >=0 and index.row() < len(self.lst):
            if not role == Qt.DisplayRole or role == Qt.EditRole:
                return False
            self.lst[index.row()] = value
            self.dataChanged.emit(index, index, [Qt.EditRole | Qt.DisplayRole])
            return True
        return False

    @Slot(int, result=int)
    def get_paltform_id(self, index: int) -> int:
        if index.isValid():
            return self.raw_data[index][-1]
        return -1

platform_combo = PlatformCombo()
platform_combo.init_data()
