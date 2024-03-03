import os
from PySide6.QtCore import QAbstractTableModel, QAbstractListModel, Qt, QModelIndex, Slot
from PySide6.QtGui import QGuiApplication
from need.db.db_model import db_model


class HotelModel(QAbstractTableModel):
    hotelName = Qt.UserRole + 1
    hotelAddr = Qt.UserRole + 2
    contact = Qt.UserRole + 3
    telephone = Qt.UserRole + 4
    comment = Qt.UserRole + 5

    _roles = {hotelName : b'hotelName', hotelAddr: b'hotelAddr', contact: b'contact', 
        telephone: b'telephone', comment : b'comment', Qt.DisplayRole : b'display'}

    def __init__(self) -> None:
        super().__init__()
        self.raw = []
        self._data = []
        self.horHeader = ["酒店名称", "酒店地址", "联系人", "联系电话", "备注"]

    @Slot()
    def init_data(self):
        self.beginResetModel()
        self.raw = db_model.get_hotels()
        self._data = [hotel[:-1] for hotel in self.raw]
        self.endResetModel()

    def data(self, index, role):
        if role == Qt.DisplayRole:
            return self._data[index.row()][index.column()]

        elif role == Qt.ToolTipRole:
            return f"This is a tool tip for [{index.row()}][{index.column()}]"

        else:
            return None

    @Slot(int, result=int)
    def rowCount(self, parent):
        return len(self._data)

    def columnCount(self, index):
        if len(self._data) > 0:
            return len(self._data[0])
        return len(self.horHeader)

    def headerData(self, section, orientation, role):
        if orientation == Qt.Horizontal and role == Qt.DisplayRole:
            return self.horHeader[section]
        return None

    def roleNames(self):
        return self._roles

    @Slot(int, result=int)
    def get_hotel_id(self, index):
        hotel_id = 0
        if index >=0 and index <= len(self.raw):
            hotel_id = self.raw[index][-1]
        return hotel_id

    @Slot(int, result=str)
    def get_name(self, index):
        name = ""
        if index >=0 and index <= len(self.raw):
            name = self.raw[index][0]
        return name

    @Slot(str, str, str, str)
    def add_hotel(self, name, addr, contacts, tel):
        db_model.insert_hotel(name, addr, contacts, tel)

    @Slot(str, str, str, str, int)
    def alter_hotel(self, name, addr, contacts, tel, index):
        hotel_id = self.get_hotel_id(index)
        if hotel_id > 0:
            db_model.update_hotel(name, addr, contacts, tel)

    @Slot(int)
    def del_hotel(self, index):
        hotel_id = self.get_hotel_id(index)
        if hotel_id > 0:
            db_model.remove_hotel(hotel_id)


hotel_model = HotelModel()
hotel_model.init_data()


class MachineModel(QAbstractTableModel):
    number = Qt.UserRole + 1
    telephone = Qt.UserRole + 2
    person = Qt.UserRole + 3
    cardType = Qt.UserRole + 4
    cardFee= Qt.UserRole + 5
    operator = Qt.UserRole + 6
    createTime = Qt.UserRole + 7

    _roles = {number : b'number', telephone: b'telephone', person: b'person', 
        cardType: b'cardType', cardFee : b'cardFee', operator: b'operator', 
        createTime: b'createTime', Qt.DisplayRole : b'display'}

    def __init__(self) -> None:
        super().__init__()
        self.raw = []
        self._data = []
        self.horHeader = ["机器编码", "手机号码", "实名人", "卡类型", "卡费用", "运营商", "创建时间"]

    @Slot()
    def init_data(self):
        self.beginResetModel()
        self.raw = db_model.get_machines()
        self._data = [machine[:-1] for machine in self.raw]
        self.endResetModel()

    def data(self, index, role):
        if role == Qt.DisplayRole:
            return self._data[index.row()][index.column()]

        elif role == Qt.ToolTipRole:
            return f"This is a tool tip for [{index.row()}][{index.column()}]"

        else:
            return None

    @Slot(int, result=int)
    def rowCount(self, parent):
        return len(self._data)

    def columnCount(self, index):
        if len(self._data) > 0:
            return len(self._data[0])
        return len(self.horHeader)

    def headerData(self, section, orientation, role):
        if orientation == Qt.Horizontal and role == Qt.DisplayRole:
            return self.horHeader[section]
        return None

    def roleNames(self):
        return self._roles

    def get_machine_id(self, index):
        hotel_id = 0
        if index >=0 and index <= len(self.raw):
            hotel_id = self.raw[index][-1]
        return hotel_id

    @Slot(int, result=str)
    def get_name(self, index):
        name = ""
        if index >=0 and index <= len(self.raw):
            name = self.raw[index][0]
        return name

    @Slot(str, str, str, str, str, str)
    def add_machine(self, number, tele, person, card_type, card_fee, operator):
        db_model.insert_machine(number, tele, person, card_type, card_fee, operator)

    @Slot(str, str, str, str, str)
    def alter_machine(self, index, tele, person, card_type, card_fee, operator):
        machine_id = self.get_machine_id(index)
        if machine_id > 0:
            db_model.update_machine(tele, person, card_type, card_fee, operator, machine_id)

    @Slot(int)
    def del_machine(self, index):
        machine_id = self.get_machine_id(index)
        if machine_id > 0:
            db_model.remove_machine(machine_id)


machine_model = MachineModel()
machine_model.init_data()


class MachineRecordModel(QAbstractTableModel):
    platform = Qt.UserRole + 1
    date = Qt.UserRole + 2
    hotel_name = Qt.UserRole + 3
    comment_date = Qt.UserRole + 4
    is_comment= Qt.UserRole + 5
    payor = Qt.UserRole + 6
    pay_channel = Qt.UserRole + 7
    payment = Qt.UserRole + 8
    is_paid = Qt.UserRole + 9
    resident = Qt.UserRole + 10
    tel = Qt.UserRole + 11
    order_img = Qt.UserRole + 12
    comment_img = Qt.UserRole + 13
    ip_addr = Qt.UserRole + 14

    _roles = {platform : b'platform', date: b'date', hotel_name: b'hotel_name', 
        comment_date: b'comment_date', is_comment : b'is_comment', payor: b'payor', 
        pay_channel: b'pay_channel', payment: b'payment', is_paid: b'is_paid', 
        resident: b'resident', tel: b'tel', order_img: b'order_img', 
        comment_img: b'comment_img', ip_addr: b'ip_addr', Qt.DisplayRole : b'display'}

    def __init__(self) -> None:
        super().__init__()
        self.raw = []
        self._data = []
        self.horHeader = ["平台", "下单日期", "酒店名称", "点评日期", "点评成功", "代付人", 
                          "付款渠道", "付款金额", "是否结账", "入住人", "电话", "评论截图", 
                          "下单截图", "IP地址"]

    @Slot(int, int, int)
    def init_data(self, platform_id, hotel_id, machine_no):
        self.beginResetModel()
        self.raw = db_model.get_machine_records(platform_id, hotel_id, machine_no)
        self._data = [record[:-1] for record in self.raw]
        self.endResetModel()

    def data(self, index, role):
        if role == Qt.DisplayRole:
            return self._data[index.row()][index.column()]

        elif role == Qt.ToolTipRole:
            return f"This is a tool tip for [{index.row()}][{index.column()}]"

        else:
            return None

    @Slot(int, result=int)
    def rowCount(self, parent):
        return len(self._data)

    def columnCount(self, index):
        if len(self._data) > 0:
            return len(self._data[0])
        return len(self.horHeader)

    def headerData(self, section, orientation, role):
        if orientation == Qt.Horizontal and role == Qt.DisplayRole:
            return self.horHeader[section]
        return None

    def roleNames(self):
        return self._roles

    @Slot(int, result='QVariantList')
    def get_comment_imgs(self, index):
        comment_imgs = []
        root_dir = os.path.dirname(QGuiApplication.arguments()[0])
        if index >=0 and index <= len(self.raw):
            comment_imgs = self.raw[index][11].split(',')
            comment_imgs = ["file:///" + root_dir + "/data/" + img for img in comment_imgs]
        return comment_imgs

    @Slot(int, result='QVariantList')
    def get_order_imgs(self, index):
        order_imgs = []
        root_dir = os.path.dirname(QGuiApplication.arguments()[0])
        if index >=0 and index <= len(self.raw):
            order_imgs = self.raw[index][12].split(',')
            order_imgs = ["file:///" + root_dir + "/data/" + img for img in order_imgs]
        return order_imgs


machine_record_model = MachineRecordModel()
# machine_record_model.init_data()


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


class HotelCombo(QAbstractListModel):
    def __init__(self) -> None:
        super().__init__()
        self.raw = []
        self.lst = []

    @Slot(str)
    def init_data(self, hotel_name):
        self.raw = db_model.search_hotels(hotel_name)
        self.beginResetModel()
        self.lst = [hotel[0] for hotel in self.raw]
        self.endResetModel()

    def rowCount(self, idx: QModelIndex=None) -> int:
        return len(self.lst)

    def roleNames(self):
        default = super().roleNames()
        return default

    @Slot(int, result=int)
    def get_hotel_id(self, index: int):
        if index >=0 and index < len(self.lst):
            return self.raw[index][-1]
        return -1

    def data(self, index, role):
        if not index.isValid():
            return None

        if role == Qt.DisplayRole:
            return self.lst[index.row()]

        if role == Qt.UserRole:
            return 99
        return


hotel_combo = HotelCombo()
hotel_combo.init_data("")


class MachineRecordDoneCombo(QAbstractListModel):
    def __init__(self) -> None:
        super().__init__()
        self.raw = []
        self.lst = []

    @Slot(int, int)
    def init_data(self, hotel_id=-1, platform_id=0):
        self.raw = db_model.search_machines_done(hotel_id, platform_id)
        self.beginResetModel()
        self.lst = [machine[0] for machine in self.raw]
        self.endResetModel()

    def rowCount(self, idx: QModelIndex=None) -> int:
        return len(self.lst)

    def roleNames(self):
        default = super().roleNames()
        return default

    def data(self, index, role):
        if not index.isValid():
            return None

        if role == Qt.DisplayRole:
            return self.lst[index.row()]

        if role == Qt.UserRole:
            return 99
        return

    @Slot(int, result=int)
    def get_machine_no(self, index):
        if index >=0 and index < len(self.lst):
            return self.raw[index][-1]
        return -1


machine_record_done_combo = MachineRecordDoneCombo()
machine_record_done_combo.init_data(hotel_id=-1, platform_id=0)


class MachineRecordUndoCombo(QAbstractListModel):
    def __init__(self) -> None:
        super().__init__()
        self.raw = []
        self.lst = []

    @Slot(int, int)
    def init_data(self, hotel_id=-1, platform_id=0):
        self.raw = db_model.search_machines_undo(hotel_id, platform_id)
        self.beginResetModel()
        self.lst = [machine[0] for machine in self.raw]
        self.endResetModel()

    def rowCount(self, idx: QModelIndex=None) -> int:
        return len(self.lst)

    def roleNames(self):
        default = super().roleNames()
        return default

    def data(self, index, role):
        if not index.isValid():
            return None

        if role == Qt.DisplayRole:
            return self.lst[index.row()]

        if role == Qt.UserRole:
            return 99
        return


machine_record_undo_combo = MachineRecordUndoCombo()
machine_record_undo_combo.init_data(hotel_id=-1, platform_id=0)


class MachineCombo(QAbstractListModel):
    def __init__(self) -> None:
        super().__init__()
        self.raw = []
        self.lst = []

    @Slot(str)
    def init_data(self, machine_name):
        self.raw = db_model.search_machines(machine_name)
        self.beginResetModel()
        self.lst = [machine[0] for machine in self.raw]
        self.endResetModel()

    def rowCount(self, idx: QModelIndex=None) -> int:
        return len(self.lst)

    def roleNames(self):
        default = super().roleNames()
        return default

    @Slot(int, result=int)
    def get_machine_number(self, index: int):
        if index >=0 and index < len(self.lst):
            return self.raw[index][-1]
        return -1

    def data(self, index, role):
        if not index.isValid():
            return None

        if role == Qt.DisplayRole:
            return self.lst[index.row()]

        if role == Qt.UserRole:
            return 99
        return


machine_combo = MachineCombo()
machine_combo.init_data("")

